# /etc/bash/bashrc
# universal bashrc

#-----------------------------
#
#-----------------------------
if [[ $- != *i* ]] ; then
        # Shell is non-interactive.  Be done now!
        return
fi

case ${TERM} in
        xterm*|rxvt*|Eterm|aterm|kterm|gnome*|interix)
                PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
                ;;
        screen)
                PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
                ;;
esac

use_color=false

safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
        && type -P dircolors >/dev/null \
        && match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
        # Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
        if type -P dircolors >/dev/null ; then
                if [[ -f ~/.dir_colors ]] ; then
                        eval $(dircolors -b ~/.dir_colors)
                elif [[ -f /etc/DIR_COLORS ]] ; then
                        eval $(dircolors -b /etc/DIR_COLORS)
                fi
        fi

        if [[ ${EUID} == 0 ]] ; then
                PS1='\[\033[01;31m\]\h\[\033[01;34m\] \w \$\[\033[00m\] '
        else
                PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
        fi
else
        if [[ ${EUID} == 0 ]] ; then
                # show root@ when we don't have colors
                PS1='\u@\h \w \$ '
        else
                PS1='\u@\h \w \$ '
        fi
fi

#-----------------------------
# Aliases for all
#-----------------------------
alias ls='sudo /bin/ls --color=auto'
alias ll='ls -ll'
alias la='ls -la'
alias 'cd..'='cd ..'
alias grep='sudo /bin/grep --colour=auto'

# Try to keep environment pollution down, EPA loves us.
unset use_color safe_term match_lhs

#-----------------------------
# Aliases for all reg.ru servers
#-----------------------------

if [[ ${HOSTNAME} =~ ".reg.ru" ]]; then
	# alias for sup_exec commands
	alias sup_exec='sudo /usr/local/bin/sup_exec'
	alias cp='sudo /usr/local/bin/sup_exec cp'
	alias mv='sudo /usr/local/bin/sup_exec mv'
	alias chown='sudo /usr/local/bin/sup_exec chown'
	alias chmod='sudo /usr/local/bin/sup_exec chmod'
	alias tar='sudo /usr/local/bin/sup_exec tar'

	# alias for sudo commands
	#alias cat='sudo /bin/cat'
	alias head='sudo /usr/bin/head'
	alias tail='sudo /usr/bin/tail'
	alias less='sudo /usr/bin/less'
	alias more='sudo /bin/more'
	alias ps='sudo /bin/ps'
	alias du='sudo /usr/bin/du'
	alias zcat='sudo /bin/zcat'
	alias locate='sudo /usr/bin/locate'
	alias find='sudo /usr/bin/find'
	alias named-checkconf='sudo /usr/sbin/named-checkconf'
	alias repquota='sudo /usr/sbin/repquota'
	alias iptables='sudo /sbin/iptables'
	alias dbroot.sh='sudo /usr/local/bin/dbroot.sh'
fi

#-----------------------------
# Aliases for all ISP servers
#-----------------------------

if [[ ${HOSTNAME} =~ "^server[0-9]{1,3}.hosting.reg.ru" ||
      ${HOSTNAME} =~ "^sbx[0-9]{1,3}.hosting.reg.ru"    ]]; then
	# alias for custom commands
	alias restore_isp_dirs.sh='sudo /usr/local/bin/restore_isp_dirs.sh'
	alias turn_php2html_on.pl='sudo /usr/local/bin/turn_php2html_on.pl'
	alias backup_user.sh='sudo /usr/local/bin/backup_user.sh'
	alias restore_from_backup.sh='sudo /usr/local/bin/restore_from_backup.sh'
	

fi

#-----------------------------
# Aliases for all CPanel servers
#-----------------------------

if [[ ${HOSTNAME} =~ "^scp[0-9]{1,3}.hosting.reg.ru" ]]; then
	alias restore_from_backup.sh='sudo /usr/local/bin/restore_from_backup.sh'
	# alias dbroot.sh='sudo /usr/local/bin/dbroot.sh'

fi

#-----------------------------
# Aliases for all Plesk servers
#-----------------------------

if [[ ${HOSTNAME} =~ "^spl[0-9]{1,3}.hosting.reg.ru" ]]; then
	alias httpdmng='sudo /usr/local/psa/admin/bin/httpdmng'
	alias dbroot.sh='sudo /usr/local/bin/dbroot.sh'
	alias fix_changed_login.sh='sudo /usr/local/bin/fix_changed_login.sh'
	#alias fix_out_of_webspace.sh='sudo /usr/local/bin/fix_out_of_webspace.sh'
	alias delete_sharethis_element_from_sb.sh='sudo /usr/local/bin/delete_sharethis_element_from_sb.sh'
	alias fix_dns_zone_exists.sh='sudo /usr/local/bin/fix_dns_zone_exists.sh'
	alias mail='/usr/local/psa/bin/mail'
    alias wpb_widgets.pl='/usr/local/bin/wpb_widgets.pl'
    alias fix_out_of_webspace.pl='/usr/local/bin/fix_out_of_webspace.pl'
	alias restore_from_backup.sh='sudo /usr/local/bin/restore_from_backup.sh'
fi

#-----------------------------
# Aliases for all DirectAdmin server
#-----------------------------

#if [[ ${HOSTNAME} =~ "^sda[0-9]{1,3}.hosting.reg.ru" ]]; then
#	alias restore_from_backup.sh='sudo /usr/local/bin/restore_from_backup.sh'
#fi

#-----------------------------
# Aliases for all backup server
#-----------------------------

if [[ ${HOSTNAME} =~ "^backup[0-9]{1,3}.hosting.reg.ru" ]]; then
	alias restore_user.sh='sudo /usr/local/fsbackup/restore_user.sh'
	alias restore_site_files_bs.sh='sudo /usr/local/fsbackup/restore_site_files_bs.sh'
fi

#-----------------------------
# Aliases for all OVZ server
#-----------------------------

if [[ ${HOSTNAME} =~ "^ovzhost[0-9]{1,3}.vps.reg.ru" ]]; then
	alias vzctl='sudo /usr/sbin/vzctl'
	alias vztop='sudo /usr/bin/vztop'
	alias vzps='sudo /bin/vzps'
	alias ls='sudo /bin/ls'
	alias less='sudo /usr/bin/less'
	alias find='sudo /usr/bin/find'
fi

#-----------------------------
# Aliases for all relay server
#-----------------------------

#if [[ ${HOSTNAME} =~ "^relay[0-9]{1,3}.hosting.reg.ru" ]]; then
#
#fi

#-----------------------------
# Aliases for all ns server
#-----------------------------

if [[ ${HOSTNAME} =~ "^ns[0-9]{1,3}.hosting.reg.ru" ]]; then
	alias killdomain='sudo /usr/local/bin/killdomain'
fi

