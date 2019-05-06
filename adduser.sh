#!/bin/bash
#set -x
error_arg(){
    echo -e "\nRun \`./useradd.sh -h' for more information." >&2
    exit 1
}

error_group(){
    echo -e "\nAt least one wrong character in group name." >&2
}

usage(){
    echo -e "\nuseradd.sh: Add local users on the system\n        ./useradd.sh [file]       --> with only one user / line\n        examples: ./useradd.sh /list_users.txt"
}

case $1 in
    */) error_arg;exit 1;;
    -h) usage;exit 1;;
    *) ;;
esac

if [ ! -f $1 ];then
    error_arg;exit 1
fi

if [[ $(awk '$0~/^.* .*$/ {print}' $1) == "* *" ]];then
    echo "No space character is allowed in the users list file.";error_arg;exit
fi

while true;do
    echo "Tell me the group : "
    read GROUP
    case ${GROUP} in
        */) error_group;continue;;
        /*) error_group;continue;;
        *) break;;
    esac
done
if [ "$(awk -F: '$1=="'${GROUP}'" {print $1}' /etc/group)" != "${GROUP}" ];then
    while true ;do
        echo -e "Group mising on the system. Do you really want to create this group now ?\n[y/n]"
        read CONFIRM_G
        if [ "${CONFIRM_G}" == "y" ];then
            groupadd ${GROUP}
            if [ $? != 0 ];then
                echo "Error : can't create group";exit
            fi
            while true;do
                echo -e "Do you want to add this group to sudoers file ?\n[y/n]"
                read CONFIRM_S
                if [ "${CONFIRM_S}" == "y" ];then
                    echo "%${GROUP}  ALL=(ALL)       ALL" >> /etc/sudoers
                    if [ $? != 0 ];then
                        echo -e "Error : can't add group to sudoers file";exit
                    else echo -e "Group added to sudoers file : $(awk '$1=="%'${GROUP}'" {print}' /etc/sudoers)";break
                    fi
                elif [ "${CONFIRM_S}" == "n" ];then
                    echo -e "Group won't be added to sudoers file";break
                else continue
                fi
            done
        elif [ "${CONFIRM_G}" == "n" ];then
            echo -e "Group won't be created";exit
        else continue
        fi
        break
    done
else
    while true;do
        echo -e "Group ${GROUP} exists. Do you really want to use this group ?\n[y/n]"
        read CONFIRM_G
        if [ "${CONFIRM_G}" == "y" ];then
            echo -e "Let's use it !";break
        elif [ "${CONFIRM_G}" == "n" ];then
            echo -e "Group won't be used";exit
        else continue
        fi
    done
    if [ -z "$(awk '$1=="%'${GROUP}'" {print $1}' /etc/sudoers)" ];then
        while true;do
            echo -e "Group ${GROUP} is not in sudoers file. Do you want to give sudo rights to this group ?\n[y/n]"
            read CONFIRM_S
            if [ "${CONFIRM_S}" == "y" ];then
                echo "%${GROUP}  ALL=(ALL)       ALL" >> /etc/sudoers
                if [ $? != 0 ];then
                    echo -e "Error : can't add group to sudoers file";exit
                    else echo -e "Group added to sudoers filei : $(awk '$1=="%'${GROUP}'" {print}' /etc/sudoers)";break
                fi
            elif [ "${CONFIRM_S}" == "n" ];then
                echo -e "Group won't be added to sudoers file";break
            else continue
            fi
        done
    else echo -e "Group already in sudoers file : $(awk '$1=="%'${GROUP}'" {print}' /etc/sudoers)"
    fi
fi

LINES=$(grep -ve ^$ $1|wc -l)
while true;do
    echo -e "Start the creation of the ${LINES} user(s) ?\n[y/n]"
    read CONFIRM_L
    if [ "${CONFIRM_L}" == "y" ];then
        echo -e "OK let's go !";break
    elif [ "${CONFIRM_L}" == "n" ];then
        echo -e "Creation canceled";exit
    else continue
    fi
done

echo -e "Tell me the password for the users :"
read PWD

while read USER ;do
    if [ -z ${USER} ];then
        continue
    fi
    if [ "$(awk -F: '$1=="'${USER}'" {print $1}' /etc/passwd)" == ${USER} ];then
        while true;do
            echo -e "User ${USER} exists. Do you want to create the next user (n will cancel the tack) ?\n [y/n]"
            read CONFIRM_U </dev/tty
            if [ "${CONFIRM_U}" == "y" ];then
                echo -e "Continuing task\n";break
            elif [ "${CONFIRM_U}" == "n" ];then
                echo -e "User creation cancelled";exit
            else continue
            fi
        done
    continue
    fi
    useradd -N -g ${GROUP} ${USER} 
    if [ $? != 0 ];then
        echo -e "Error : can't create user \"${USER}\"";exit
        else echo -e "User \"${USER}\" created"
    fi
    echo ${PWD} | passwd --stdin ${USER}
    chage -I 15 -M 90 -m 1 -W 7 ${USER}
    if [ $? != 0 ];then
        echo -e "Error : can't secure \"${USER}\" account";exit
        else echo -e "Account \"${USER}\" secured"
    fi
    passwd -e ${USER}
    echo -e "\n"
done < $1
echo -e "All users created successfully"
