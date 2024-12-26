#!/bin/bash

echo
echo " ██████╗ ██╗███████╗ ██████╗ ███╗   ██╗"
echo " ██╔══██╗██║██╔════╝██╔═══██╗████╗  ██║"
echo " ██████╔╝██║███████╗██║   ██║██╔██╗ ██║"
echo " ██╔══██╗██║╚════██║██║   ██║██║╚██╗██║"
echo " ██████╔╝██║███████║╚██████╔╝██║ ╚████║"
echo " ╚═════╝ ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝"
echo " ██████╗  █████╗  ██████╗██╗  ██╗██╗   ██╗██████╗"
echo " ██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██║   ██║██╔══██╗"
echo " ██████╔╝███████║██║     █████╔╝ ██║   ██║██████╔╝"
echo " ██╔══██╗██╔══██║██║     ██╔═██╗ ██║   ██║██╔═══╝"
echo " ██████╔╝██║  ██║╚██████╗██║  ██╗╚██████╔╝██║"
echo " ╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝"
echo
echo "Backup Automation Script Framework"
echo
echo "###################################################"
echo
echo "SCRIPT INFO"
echo
echo "Author:    SilverLPs"
echo "Version:   0.1"
echo "Github:    Link"
echo
echo "###################################################"
echo
echo "RUNTIME INFO"
echo
echo "Host:      $(uname -n)"
if [[ -f /etc/os-release ]]; then
	while IFS='=' read -r key value; do
		case "$key" in
			NAME) bisonbackup_runtimeinfo_os_name="${value//\"/}" ;;
			VERSION) bisonbackup_runtimeinfo_os_version="${value//\"/}" ;;
		esac
	done < /etc/os-release
	bisonbackup_runtimeinfo_os="$bisonbackup_runtimeinfo_os_name $bisonbackup_runtimeinfo_os_version"
else
	bisonbackup_runtimeinfo_os="Unknown"
fi
echo "OS:        $bisonbackup_runtimeinfo_os"
echo "Kernel:    $(uname -sr)"
echo "Path:      $(pwd)"
echo "Shell:     $SHELL"
echo "Time:      $(date +\%Y\%m\%d)-$(date +\%H\%M\%S)"
echo "User:      $(whoami)"
echo
echo "###################################################"
echo
echo "BisonBackup finished"
echo



#TODO:

#There should be modules to abstract operations into a single syntax for example for gameserver backups or discordchatexporter or borgbackup but also for simple things like copy or download jobs
#The modules will have general parameters like source or destination and also specific parameters that will depend on the abstracted process
#The variables will be sent to the module via arguments
#The modules abstraction will make handling different backup tasks with different backend processes more easy because the syntax for the variables will be the same and they can be configured in one place called plan
#A plan is like an ansible-playbook, the bisonbackup command will be run with just this file as an argument and then the plan will contain the general info like plans name the plans standard user and current dir to run tasks with (if not specified differently for a specific task) and the path to the modules and then the tasks that will call the modules with their variables. BisonBackup will automatically pass the listed Variables to the module scripts as variables. The tasks can also be specified with a different user (also for sudo) or current dir to switch to only for the specific task
#The modules are just scripts that also could be run just on their own, so everyone can make simple scripts as modules with just some commandline arguments and it will work

#There can also be single scripts that can be executed by a module that will just run a command or a script as is

#The modules will be separated into a second github repo called bisonbackup.general (like in Ansible) so people will be able to create their own modules and just put them into the modules folder and then use them

