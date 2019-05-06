#!/bin/bash
if [ $(uname) == "Linux" ];then
    LOG_MINAGE=$(awk '$1=="PASS_MIN_DAYS" {print $2}' /etc/login.defs)
    LOG_MAXAGE=$(awk '$1=="PASS_MAX_DAYS" {print $2}' /etc/login.defs)
    LOG_MINLEN=$(awk '$1=="PASS_MIN_LEN" {print $2}' /etc/login.defs)
    LOG_PWDWARNTIME=$(awk '$1=="PASS_WARN_AGE" {print $2}' /etc/login.defs)

    for i in $(awk '$1=="password" && $3=="pam_unix.so" && $0~/^.*remember=.*$/ {print}' /etc/pam.d/password-auth);do
        if [[ $i = remember=* ]];then
            PAMP_REMEMBER=$(echo $i |awk -F= '{print $2}')
        fi
    done
    for i in $(awk '$1=="password" && $3=="pam_unix.so" && $0~/^.*remember=.*$/ {print}' /etc/pam.d/system-auth);do
        if [[ $i = remember=* ]];then
            PAMS_REMEMBER=$(echo $i |awk -F= '{print $2}')
        fi
    done

    if [[ $(uname -r) = 3.10.0-* ]];then
        PAMQ_MINLEN=$(awk '$1=="minlen" {print $3}' /etc/security/pwquality.conf)
        PAMQ_MINDIGIT=$(awk '$1=="dcredit" {print $3}' /etc/security/pwquality.conf)
        PAMQ_MINALPHA=$(awk '$1=="lcredit" {print $3}' /etc/security/pwquality.conf)
        PAMQ_MINUPPER=$(awk '$1=="ucredit" {print $3}' /etc/security/pwquality.conf)
        PAMQ_MINSPECIAL=$(awk '$1=="ocredit" {print $3}' /etc/security/pwquality.conf)
        for i in $(awk '$1=="auth" && $3=="pam_faillock.so" {print}' /etc/pam.d/password-auth);do
            if [[ $i = deny=* ]];then
                PAMP_DENY=$(echo $i |awk -F= '{print $2}')
            fi
        done

        for i in $(awk '$1=="auth" && $3=="pam_faillock.so" {print}' /etc/pam.d/system-auth);do
            if [[ $i = deny=* ]];then
                PAMS_DENY=$(echo $i |awk -F= '{print $2}')
            fi
        done
        echo "$(hostname);RH7;${PAMP_DENY};${PAMS_DENY};${LOG_MAXAGE};${LOG_MINAGE};${PAMQ_MINLEN};${PAMQ_MINALPHA};${PAMQ_MINUPPER};${PAMQ_MINDIGIT};${PAMQ_MINSPECIAL};${LOG_PWDWARNTIME};${PAMP_REMEMBER};${PAMS_REMEMBER}"
    fi
    
    if [[ $(uname -r) = 2.6.32-* ]];then
        for i in $(awk '$1=="auth" && $3=="pam_tally2.so" {print}' /etc/pam.d/password-auth);do
            if [[ $i = deny=* ]];then
                PAMP_DENY=$(echo $i |awk -F= '{print $2}')
            fi
        done
        for i in $(awk '$1=="auth" && $3=="pam_tally2.so" {print}' /etc/pam.d/system-auth);do
            if [[ $i = deny=* ]];then
                PAMS_DENY=$(echo $i |awk -F= '{print $2}')
            fi
        done    
        for i in $(awk '$1=="password" && $3=="pam_cracklib.so" {print}' /etc/pam.d/password-auth);do
            if [[ $i = minlength=* ]];then
                PAMP_MINLEN=$(echo $i |awk -F= '{print $2}')
            fi
            if [[ $i = lcredit=* ]];then
                PAMP_MINALPHA=$(echo $i |awk -F= '{print $2}')
            fi
            if [[ $i = ucredit=* ]];then
                PAMP_MINUPPER=$(echo $i |awk -F= '{print $2}')
            fi
            if [[ $i = dcredit=* ]];then
                PAMP_MINDIGIT=$(echo $i |awk -F= '{print $2}')
            fi
            if [[ $i = ocredit=* ]];then
                PAMP_MINSPECIAL=$(echo $i |awk -F= '{print $2}')
            fi
        done
        for i in $(awk '$1=="password" && $3=="pam_cracklib.so" {print}' /etc/pam.d/system-auth);do
            if [[ $i = minlength=* ]];then
                PAMS_MINLEN=$(echo $i |awk -F= '{print $2}')
            fi
            if [[ $i = lcredit=* ]];then
                PAMS_MINALPHA=$(echo $i |awk -F= '{print $2}')
            fi
            if [[ $i = ucredit=* ]];then
                PAMS_MINUPPER=$(echo $i |awk -F= '{print $2}')
            fi
            if [[ $i = dcredit=* ]];then
                PAMS_MINDIGIT=$(echo $i |awk -F= '{print $2}')
            fi
            if [[ $i = ocredit=* ]];then
                PAMS_MINSPECIAL=$(echo $i |awk -F= '{print $2}')
            fi
        done
    echo "$(hostname);RH6;${PAMP_DENY};${PAMS_DENY};${LOG_MAXAGE};${LOG_MINAGE};${PAMP_MINLEN};${PAMS_MINLEN};${PAMP_MINALPHA};${PAMS_MINALPHA};${PAMP_MINUPPER};${PAMS_MINUPPER};${PAMP_MINDIGIT};${PAMS_MINDIGIT};${PAMS_MINSPECIAL};${LOG_PWDWARNTIME};${PAMP_REMEMBER};${PAMS_REMEMBER}"
    fi
    if [[ $(uname -r) = 2.6.18-* ]] || [[ $(uname -r) = 2.6.9-* ]] ;then
        for i in $(awk '$1=="auth" && $3=="pam_tally2.so" {print}' /etc/pam.d/system-auth);do
            if [[ $i = deny=* ]];then
                PAMS_DENY=$(echo $i |awk -F= '{print $2}')
            fi
        done
        for i in $(awk '$1=="password" && $3=="pam_cracklib.so" {print}' /etc/pam.d/system-auth);do
            if [[ $i = minlength=* ]];then
                PAMS_MINLEN=$(echo $i |awk -F= '{print $2}')
            fi
            if [[ $i = lcredit=* ]];then
                PAMS_MINALPHA=$(echo $i |awk -F= '{print $2}')
            fi
            if [[ $i = ucredit=* ]];then
                PAMS_MINUPPER=$(echo $i |awk -F= '{print $2}')
            fi
            if [[ $i = dcredit=* ]];then
                PAMS_MINDIGIT=$(echo $i |awk -F= '{print $2}')
            fi
            if [[ $i = ocredit=* ]];then
                PAMS_MINSPECIAL=$(echo $i |awk -F= '{print $2}')
            fi
        done
    echo "$(hostname);RH4-5;${PAMS_DENY};${LOG_MAXAGE};${LOG_MINAGE};${PAMS_MINLEN};${PAMS_MINALPHA};${PAMS_MINUPPER};${PAMS_MINDIGIT};${PAMS_MINSPECIAL};${LOG_PWDWARNTIME};${PAMS_REMEMBER}"
    fi
fi
