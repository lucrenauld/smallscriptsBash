#!/bin/bash
############################################AUDIT PAM#############################################
if [ $(uname) = "Linux" ];then
    if [[ $(uname -r) = 2.6.9-* ]];then
        echo "$(hostname) RHEL4"
        if [ "$(find /etc/pam.d/ -name system-auth)" == "/etc/pam.d/system-auth" ];then
            echo "File system-auth exists"
            else echo "File system-auth doesn't exist";exit
        fi
    fi
    if [[ $(uname -r) = 2.6.18-* ]];then
        echo "$(hostname) RHEL5"
        if [ "$(find /etc/pam.d/ -name system-auth-ac)" == "/etc/pam.d/system-auth-ac" ];then
            echo "File system-auth-ac exists"
            if [[ "$(ls -l /etc/pam.d/system-auth)" = lrwxrwxrwx*system-auth-ac ]];then
                echo "Symbolic link system-auth OK"
                else echo "Symbolic link system-auth NOK";exit
            fi
            else echo "File system-auth-ac doesn't exist";exit
        fi
    fi
    if [[ $(uname -r) = 2.6.32-* ]];then
        echo "$(hostname) RHEL6"
        if [ "$(find /etc/pam.d/ -name system-auth-ac)" == "/etc/pam.d/system-auth-ac" ];then
            echo "File system-auth-ac exists"
            if [[ "$(ls -l /etc/pam.d/system-auth)" = lrwxrwxrwx.*system-auth-ac ]];then
                echo "Symbolic link system-auth OK"
                else echo "Symbolic link system-auth NOK";exit
            fi
            else echo "File system-auth-ac doesn't exist";exit
        fi
        if [ "$(find /etc/pam.d/ -name password-auth-ac)" == "/etc/pam.d/password-auth-ac" ];then
            echo "File password-auth-ac exists"
            if [[ "$(ls -l /etc/pam.d/password-auth)" = lrwxrwxrwx.*password-auth-ac ]];then
                echo "Symbolic link password-auth OK"
                else echo "Symbolic link password-auth NOK";exit
            fi
            else echo "File password-auth-ac doesn't exist";exit
        fi
    fi
    if [[ $(uname -r) = 3.10.0-* ]];then
        echo "$(hostname) RHEL7"
        if [ "$(find /etc/pam.d/ -name system-auth-ac)" == "/etc/pam.d/system-auth-ac" ];then
            echo "File system-auth-ac exists"
            if [[ "$(ls -l /etc/pam.d/system-auth)" = lrwxrwxrwx.*system-auth-ac ]];then
                echo "Symbolic link system-auth OK"
                else echo "Symbolic link system-auth NOK";exit
            fi
            else echo "File system-auth-ac doesn't exist";exit
        fi
        if [ "$(find /etc/pam.d/ -name password-auth-ac)" == "/etc/pam.d/password-auth-ac" ];then
            echo "File password-auth-ac exists"
            if [[ "$(ls -l /etc/pam.d/password-auth)" = lrwxrwxrwx.*password-auth-ac ]];then
                echo "Symbolic link password-auth OK"
                else echo "Symbolic link password-auth NOK";exit
            fi
            else echo "File password-auth-ac doesn't exist"i;exit
        fi
        if [ "$(find /etc/security/ -name pwquality.conf)" == "/etc/security/pwquality.conf" ];then
            echo "File pwquality exists"
            else echo "file pwquality doesn't exist";exit
        fi
    fi

##################################################################################################
    if [[ $(uname -r) = 2.6.9-* ]];then
        if [ ! -f /etc/login.defs.old ];then
            cp -p /etc/login.defs /etc/login.defs.old
        fi
    cat <<EOF > /etc/login.defs
# *REQUIRED*
#   Directory where mailboxes reside, _or_ name of file, relative to the
#   home directory.  If you _do_ define both, MAIL_DIR takes precedence.
#   QMAIL_DIR is for Qmail
#
#QMAIL_DIR      Maildir
MAIL_DIR        /var/spool/mail
#MAIL_FILE      .mail

# Password aging controls:
#
#       PASS_MAX_DAYS   Maximum number of days a password may be used.
#       PASS_MIN_DAYS   Minimum number of days allowed between password changes.
#       PASS_MIN_LEN    Minimum acceptable password length.
#       PASS_WARN_AGE   Number of days warning given before a password expires.
#
PASS_MAX_DAYS   99999
PASS_MIN_DAYS   1
PASS_MIN_LEN    15
PASS_WARN_AGE   7

#
# Min/max values for automatic uid selection in useradd
#
UID_MIN                   500
UID_MAX                 60000

#
# Min/max values for automatic gid selection in groupadd
#
GID_MIN                   500
GID_MAX                 60000

#
# If defined, this command is run when removing a user.
# It should remove any at/cron/print jobs etc. owned by
# the user to be removed (passed as the first argument).
#
#USERDEL_CMD    /usr/sbin/userdel_local

#
# If useradd should create home directories for users by default
# On RH systems, we do. This option is overridden with the -M flag on
# useradd command line.
#
CREATE_HOME     yes
EOF
        if [ ! -f /etc/pam.d/system-auth.old ];then
            cp -p /etc/pam.d/system-auth /etc/pam.d/system-auth.old
        fi
        cat <<EOF > /etc/pam.d/system-auth
#%PAM-1.0
# This file is auto-generated.
# User changes will be destroyed the next time authconfig is run.
auth        required      pam_env.so
auth        required      pam_tally2.so deny=5 onerr=fail unlock_time=900
auth        sufficient    pam_fprintd.so
auth        sufficient    pam_unix.so nullok try_first_pass
auth        requisite     pam_succeed_if.so uid >= 500 quiet
auth        required      pam_deny.so

account     required      pam_tally2.so
account     required      pam_unix.so
account     sufficient    pam_localuser.so
account     sufficient    pam_succeed_if.so uid < 500 quiet
account     required      pam_permit.so

password    requisite     pam_cracklib.so try_first_pass retry=3 minlength=15 lcredit=-1 ucredit=-1 dcredit=-1 ocredit=-1
password    sufficient    pam_unix.so sha512 remember=4 shadow nullok try_first_pass use_authtok
password    required      pam_deny.so

session     optional      pam_keyinit.so revoke
session     required      pam_limits.so
session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
session     required      pam_unix.so
EOF
    fi
    if [[ $(uname -r) = 2.6.18-* ]];then
        if [ ! -f /etc/login.defs.old ];then
            cp -p /etc/login.defs /etc/login.defs.old
        fi
    cat <<EOF > /etc/login.defs
# *REQUIRED*
#   Directory where mailboxes reside, _or_ name of file, relative to the
#   home directory.  If you _do_ define both, MAIL_DIR takes precedence.
#   QMAIL_DIR is for Qmail
#
#QMAIL_DIR      Maildir
MAIL_DIR        /var/spool/mail
#MAIL_FILE      .mail

# Password aging controls:
#
#       PASS_MAX_DAYS   Maximum number of days a password may be used.
#       PASS_MIN_DAYS   Minimum number of days allowed between password changes.
#       PASS_MIN_LEN    Minimum acceptable password length.
#       PASS_WARN_AGE   Number of days warning given before a password expires.
#
PASS_MAX_DAYS   99999
PASS_MIN_DAYS   1
PASS_MIN_LEN    15
PASS_WARN_AGE   7

#
# Min/max values for automatic uid selection in useradd
#
UID_MIN                   500
UID_MAX                 60000

#
# Min/max values for automatic gid selection in groupadd
#
GID_MIN                   500
GID_MAX                 60000

#
# If defined, this command is run when removing a user.
# It should remove any at/cron/print jobs etc. owned by
# the user to be removed (passed as the first argument).
#
#USERDEL_CMD    /usr/sbin/userdel_local

#
# If useradd should create home directories for users by default
# On RH systems, we do. This option is overridden with the -m flag on
# useradd command line.
#
CREATE_HOME     yes

# The permission mask is initialized to this value. If not specified,
# the permission mask will be initialized to 022.
UMASK           077

# This enables userdel to remove user groups if no members exist.
#
USERGROUPS_ENAB yes

# Use MD5 or DES to encrypt password? Red Hat use MD5 by default.
MD5_CRYPT_ENAB yes

ENCRYPT_METHOD SHA512
EOF
        if [ ! -f /etc/pam.d/system-auth-ac.old ];then
            cp -p /etc/pam.d/system-auth-ac /etc/pam.d/system-auth-ac.old
        fi 
        cat <<EOF > /etc/pam.d/system-auth-ac
#%PAM-1.0
# This file is auto-generated.
# User changes will be destroyed the next time authconfig is run.
auth        required      pam_env.so
auth        required      pam_tally2.so deny=5 onerr=fail unlock_time=900
auth        sufficient    pam_fprintd.so
auth        sufficient    pam_unix.so nullok try_first_pass
auth        requisite     pam_succeed_if.so uid >= 500 quiet
auth        required      pam_deny.so

account     required      pam_tally2.so
account     required      pam_unix.so
account     sufficient    pam_localuser.so
account     sufficient    pam_succeed_if.so uid < 500 quiet
account     required      pam_permit.so

password    requisite     pam_cracklib.so try_first_pass retry=3 minlength=15 lcredit=-1 ucredit=-1 dcredit=-1 ocredit=-1
password    sufficient    pam_unix.so sha512 remember=4 shadow nullok try_first_pass use_authtok
password    required      pam_deny.so

session     optional      pam_keyinit.so revoke
session     required      pam_limits.so
session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
session     required      pam_unix.so
EOF
    fi
    if [[ $(uname -r) = 2.6.32-* ]];then
        if [ ! -f /etc/login.defs.old ];then
            cp -p /etc/login.defs /etc/login.defs.old
        fi
    cat <<EOF > /etc/login.defs
#
# Please note that the parameters in this configuration file control the
# behavior of the tools from the shadow-utils component. None of these
# tools uses the PAM mechanism, and the utilities that use PAM (such as the
# passwd command) should therefore be configured elsewhere. Refer to
# /etc/pam.d/system-auth for more information.
#

# *REQUIRED*
#   Directory where mailboxes reside, _or_ name of file, relative to the
#   home directory.  If you _do_ define both, MAIL_DIR takes precedence.
#   QMAIL_DIR is for Qmail
#
#QMAIL_DIR      Maildir
MAIL_DIR        /var/spool/mail
#MAIL_FILE      .mail

# Password aging controls:
#
#       PASS_MAX_DAYS   Maximum number of days a password may be used.
#       PASS_MIN_DAYS   Minimum number of days allowed between password changes.
#       PASS_MIN_LEN    Minimum acceptable password length.
#       PASS_WARN_AGE   Number of days warning given before a password expires.
#
PASS_MAX_DAYS   99999
PASS_MIN_DAYS   1
PASS_MIN_LEN    15
PASS_WARN_AGE   7

#
# Min/max values for automatic uid selection in useradd
#
UID_MIN                   500
UID_MAX                 60000

#
# Min/max values for automatic gid selection in groupadd
#
GID_MIN                   500
GID_MAX                 60000

#
# If defined, this command is run when removing a user.
# It should remove any at/cron/print jobs etc. owned by
# the user to be removed (passed as the first argument).
#
#USERDEL_CMD    /usr/sbin/userdel_local

#
# If useradd should create home directories for users by default
# On RH systems, we do. This option is overridden with the -m flag on
# useradd command line.
#
CREATE_HOME     yes

# The permission mask is initialized to this value. If not specified,
# the permission mask will be initialized to 022.
UMASK           077

# This enables userdel to remove user groups if no members exist.
#
USERGROUPS_ENAB yes

# Use SHA512 to encrypt password.
ENCRYPT_METHOD SHA512
EOF
        if [ ! -f /etc/pam.d/password-auth-ac.old ];then
            cp -p /etc/pam.d/password-auth-ac /etc/pam.d/password-auth-ac.old
        fi
        cat <<EOF > /etc/pam.d/password-auth-ac
#%PAM-1.0
# This file is auto-generated.
# User changes will be destroyed the next time authconfig is run.
auth        required      pam_env.so
auth        required      pam_tally2.so deny=5 onerr=fail unlock_time=900
auth        sufficient    pam_fprintd.so
auth        sufficient    pam_unix.so nullok try_first_pass
auth        requisite     pam_succeed_if.so uid >= 500 quiet
auth        required      pam_deny.so

account     required      pam_tally2.so
account     required      pam_unix.so
account     sufficient    pam_localuser.so
account     sufficient    pam_succeed_if.so uid < 500 quiet
account     required      pam_permit.so

password    requisite     pam_cracklib.so try_first_pass retry=3 minlength=15 lcredit=-1 ucredit=-1 dcredit=-1 ocredit=-1
password    sufficient    pam_unix.so sha512 remember=4 shadow nullok try_first_pass use_authtok
password    required      pam_deny.so

session     optional      pam_keyinit.so revoke
session     required      pam_limits.so
session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
session     required      pam_unix.so
EOF
        if [ ! -f /etc/pam.d/system-auth-ac.old ];then
            cp -p /etc/pam.d/system-auth-ac /etc/pam.d/system-auth-ac.old
        fi
        cat <<EOF > /etc/pam.d/system-auth-ac
#%PAM-1.0
# This file is auto-generated.
# User changes will be destroyed the next time authconfig is run.
auth        required      pam_env.so
auth        required      pam_tally2.so deny=5 onerr=fail unlock_time=900
auth        sufficient    pam_fprintd.so
auth        sufficient    pam_unix.so nullok try_first_pass
auth        requisite     pam_succeed_if.so uid >= 500 quiet
auth        required      pam_deny.so

account     required      pam_tally2.so
account     required      pam_unix.so
account     sufficient    pam_localuser.so
account     sufficient    pam_succeed_if.so uid < 500 quiet
account     required      pam_permit.so

password    requisite     pam_cracklib.so try_first_pass retry=3 minlength=15 lcredit=-1 ucredit=-1 dcredit=-1 ocredit=-1
password    sufficient    pam_unix.so sha512 remember=4 shadow nullok try_first_pass use_authtok
password    required      pam_deny.so

session     optional      pam_keyinit.so revoke
session     required      pam_limits.so
session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
session     required      pam_unix.so
EOF
    fi
    if [[ $(uname -r) = 3.10.0-* ]];then
        if [ ! -f /etc/login.defs.old ];then
            cp -p /etc/login.defs /etc/login.defs.old
        fi
    cat <<EOF > /etc/login.defs
#
# Please note that the parameters in this configuration file control the
# behavior of the tools from the shadow-utils component. None of these
# tools uses the PAM mechanism, and the utilities that use PAM (such as the
# passwd command) should therefore be configured elsewhere. Refer to
# /etc/pam.d/system-auth for more information.
#

# *REQUIRED*
#   Directory where mailboxes reside, _or_ name of file, relative to the
#   home directory.  If you _do_ define both, MAIL_DIR takes precedence.
#   QMAIL_DIR is for Qmail
MAIL_DIR        /var/spool/mail
#MAIL_FILE      .mail

# Password aging controls:
#
#       PASS_MAX_DAYS   Maximum number of days a password may be used.
# #     PASS_MIN_DAYS   Minimum number of days allowed between password changes.
#       PASS_MIN_LEN    Minimum acceptable password length.
#       PASS_WARN_AGE   Number of days warning given before a password expires.
#
PASS_MAX_DAYS   9999
PASS_MIN_DAYS   1
PASS_MIN_LEN    15
PASS_WARN_AGE   7

#
# Min/max values for automatic uid selection in useradd
#
UID_MIN                  1000
UID_MAX                 60000
# System accounts
SYS_UID_MIN               201
SYS_UID_MAX               999

#
# Min/max values for automatic gid selection in groupadd
#
GID_MIN                  1000
GID_MAX                 60000
# System accounts
SYS_GID_MIN               201
SYS_GID_MAX               999

#
# If defined, this command is run when removing a user.
# It should remove any at/cron/print jobs etc. owned by
# the user to be removed (passed as the first argument).
#
#USERDEL_CMD    /usr/sbin/userdel_local

#
# If useradd should create home directories for users by default
# On RH systems, we do. This option is overridden with the -m flag on
# useradd command line.
#
CREATE_HOME     yes

# The permission mask is initialized to this value. If not specified,
# the permission mask will be initialized to 022.
UMASK           077

# This enables userdel to remove user groups if no members exist.
#
USERGROUPS_ENAB yes

# Use SHA512 to encrypt password.
ENCRYPT_METHOD SHA512
EOF
        if [ ! -f /etc/pam.d/password-auth-ac.old ];then
            cp -p /etc/pam.d/password-auth-ac /etc/pam.d/password-auth-ac.old
        fi
        cat <<EOF > /etc/pam.d/password-auth-ac
#%PAM-1.0
# This file is auto-generated.
# User changes will be destroyed the next time authconfig is run.
auth        required      pam_env.so
auth            required          pam_faillock.so preauth silent audit deny=5 unlock_time=900 fail_interval=900
auth        sufficient    pam_unix.so nullok try_first_pass
auth            [default=die] pam_faillock.so authfail audit deny=5 unlock_time=900 fail_interval=900
auth        requisite     pam_succeed_if.so uid >= 1000 quiet_success
auth        required      pam_deny.so

account         required          pam_faillock.so
account     required      pam_unix.so
account     sufficient    pam_localuser.so
account     sufficient    pam_succeed_if.so uid < 1000 quiet
account     required      pam_permit.so

password        requisite         pam_pwquality.so try_first_pass local_users_only retry=3
password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok remember=4
password    required      pam_deny.so

session     optional      pam_keyinit.so revoke
session     required      pam_limits.so
-session     optional      pam_systemd.so
session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
session     required      pam_unix.so
EOF
        if [ ! -f /etc/pam.d/system-auth-ac.old ];then
            cp -p /etc/pam.d/system-auth-ac /etc/pam.d/system-auth-ac.old
        fi
        cat <<EOF > /etc/pam.d/system-auth-ac
#%PAM-1.0
# This file is auto-generated.
# User changes will be destroyed the next time authconfig is run.
auth        required      pam_env.so
auth        required          pam_faillock.so preauth silent audit deny=5 unlock_time=900 fail_interval=900
auth        sufficient    pam_unix.so nullok try_first_pass
auth        [default=die] pam_faillock.so authfail audit deny=5 unlock_time=900 fail_interval=900
auth        requisite     pam_succeed_if.so uid >= 1000 quiet_success
auth        required      pam_deny.so

account     required          pam_faillock.so
account     required      pam_unix.so
account     sufficient    pam_localuser.so
account     sufficient    pam_succeed_if.so uid < 1000 quiet
account     required      pam_permit.so

password    requisite         pam_pwquality.so try_first_pass local_users_only retry=3
password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok remember=4
password    required      pam_deny.so

session     optional      pam_keyinit.so revoke
session     required      pam_limits.so
-session     optional      pam_systemd.so
session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
session     required      pam_unix.so
EOF
        if [ ! -f /etc/security/pwquality.conf.old ];then
            cp -p /etc/security/pwquality.conf /etc/security/pwquality.conf.old
        fi
        cat <<EOF > /etc/security/pwquality.conf
# Configuration for systemwide password quality limits
# Defaults:
#
# Number of characters in the new password that must not be present in the
# old password.
# difok = 5
#
# Minimum acceptable size for the new password (plus one if
# credits are not disabled which is the default). (See pam_cracklib manual.)
# Cannot be set to lower value than 6.
minlen = 15
#
# The maximum credit for having digits in the new password. If less than 0
# it is the minimum number of digits in the new password.
dcredit = -1
#
# The maximum credit for having uppercase characters in the new password.
# If less than 0 it is the minimum number of uppercase characters in the new
# password.
ucredit = -1
#
# The maximum credit for having lowercase characters in the new password.
# If less than 0 it is the minimum number of lowercase characters in the new
# password.
lcredit = -1
#
# The maximum credit for having other characters in the new password.
# If less than 0 it is the minimum number of other characters in the new
# password.
ocredit = -1
#
# The minimum number of required classes of characters for the new
# password (digits, uppercase, lowercase, others).
# minclass = 0
#
# The maximum number of allowed consecutive same characters in the new password.
# The check is disabled if the value is 0.
# maxrepeat = 0
#
# The maximum number of allowed consecutive characters of the same class in the
# new password.
# The check is disabled if the value is 0.
# maxclassrepeat = 0
#
# Whether to check for the words from the passwd entry GECOS string of the user.
# The check is enabled if the value is not 0.
# gecoscheck = 0
#
# Path to the cracklib dictionaries. Default is to use the cracklib default.
# dictpath =
# minlen = 10
EOF
    fi
fi


if [ $(uname) = "AIX" ];then
    echo "$(hostname) AIX$(oslevel)"
    if [[ $(awk ' $1=="pwdwarntime" && $2=="=" {print $3}' /etc/security/user) != "7" ]];then
        chsec -f /etc/security/user -s default -a pwdwarntime = 7
    fi
    if [[ $(awk ' $1=="loginretries" && $2=="=" {print $3}' /etc/security/user) != "5" ]];then
        chsec -f /etc/security/user -s default -a loginretries = 5
    fi
    if [[ $(awk ' $1=="histsize" && $2=="=" {print $3}' /etc/security/user) != "4" ]];then
        chsec -f /etc/security/user -s default -a histsize = 4
    fi
    if [[ $(awk ' $1=="minage" && $2=="=" {print $3}' /etc/security/user) != "1" ]];then
        chsec -f /etc/security/user -s default -a minage = 1
    fi
    if [[ $(awk ' $1=="minalpha" && $2=="=" {print $3}' /etc/security/user) != "1" ]];then
        chsec -f /etc/security/user -s default -a minalpha = 1
    fi
    if [[ $(awk ' $1=="minother" && $2=="=" {print $3}' /etc/security/user) != "1" ]];then
        chsec -f /etc/security/user -s default -a minother = 1
    fi
    if [[ $(awk ' $1=="minlen" && $2=="=" {print $3}' /etc/security/user) != "15" ]];then
        chsec -f /etc/security/user -s default -a minlen = 15
    fi
    if [[ $(awk ' $1=="minupperalpha" && $2=="=" {print $3}' /etc/security/user) != "1" ]];then
        chsec -f /etc/security/user -s default -a minupperalpha = 1
    fi
    if [[ $(awk ' $1=="mindigit" && $2=="=" {print $3}' /etc/security/user) != "1" ]];then
        chsec -f /etc/security/user -s default -a mindigit = 1
    fi
    if [[ $(awk ' $1=="minspecialchar" && $2=="=" {print $3}' /etc/security/user) != "1" ]];then
        chsec -f /etc/security/user -s default -a minspecialchar = 1
    fi
    echo "pwdwarntime = $(awk ' $1=="pwdwarntime" && $2=="=" {print $3;exit}' /etc/security/user)"
    echo "loginretries = $(awk ' $1=="loginretries" && $2=="=" {print $3;exit}' /etc/security/user)"
    echo "histsize = $(awk ' $1=="histsize" && $2=="=" {print $3;exit}' /etc/security/user)"
    echo "minage = $(awk ' $1=="minage" && $2=="=" {print $3;exit}' /etc/security/user)"
    echo "minalpha = $(awk ' $1=="minalpha" && $2=="=" {print $3;exit}' /etc/security/user)"
    echo "minother = $(awk ' $1=="minother" && $2=="=" {print $3;exit}' /etc/security/user)"
    echo "minlen = $(awk ' $1=="minlen" && $2=="=" {print $3;exit}' /etc/security/user)"
    echo "minupperalpha = $(awk ' $1=="minupperalpha" && $2=="=" {print $3;exit}' /etc/security/user)"
    echo "mindigit = $(awk ' $1=="mindigit" && $2=="=" {print $3;exit}' /etc/security/user)"
    echo "minspecialchar = $(awk ' $1=="minspecialchar" && $2=="=" {print $3;exit}' /etc/security/user)"
    echo "maxage = $(awk ' $1=="maxage" && $2=="=" {print $3;exit}' /etc/security/user)"
fi
