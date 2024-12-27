get_os_name() {
        if [[ -f /etc/os-release ]]; then
                while IFS='=' read -r key value; do
                        case "$key" in
                                NAME) bisonbackup_runtimeinfo_os_name="${value//\"/}" ;;
                                VERSION) bisonbackup_runtimeinfo_os_version="${value//\"/}" ;;
                        esac
                done < /etc/os-release
                echo "$bisonbackup_runtimeinfo_os_name $bisonbackup_runtimeinfo_os_version"
        else
                echo "Unknown"
        fi
}

load_plan() {
    ini_file="$(realpath $1)"
    local section=""
    local key=""
    local value=""

    while IFS='=' read -r key value; do
        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs)
        
        if [[ $key =~ ^\[.*\]$ ]]; then
            section=$(echo "$key" | sed 's/\[\(.*\)\]/\1/')
        else
            if [[ $section == "Plan" && -n $key && -n $value ]]; then
                case $key in
                    Name)
                        PlanName="$value"
                        ;;
                    Path)
                        PlanPath="$value"
                        ;;
                    ModulePath)
                        PlanModulePath="$(realpath $value)"
                        ;;
                esac
            fi
        fi
    done < "$ini_file"
    if [[ -z "$PlanPath" ]]; then
        PlanPath=$(pwd)
    else
        cd "$PlanPath" || { echo "Error: The directory '$PlanPath' doesn't exist."; exit 1; }
    fi
}

process_task() {
    local section="$1"
    local task_path=""
    local module=""
    local package=""
    local arguments=()

    while IFS='=' read -r key value; do
        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs)

        case $key in
            TaskModule)
                module="$value"
                ;;
            TaskPath)
                task_path="$value"
                ;;
            *)
                arguments+=("$key=$value")
                ;;
        esac
    done < <(sed -n "/\[$section\]/,/\[.*\]/p" "$ini_file" | sed '/^\[.*\]$/d')
    
    if [[ -n "$task_path" && -d "$task_path" ]]; then
        cd "$task_path" || { echo "Failed to change directory to $task_path"; return 1; }
    fi

    IFS='.' read -r package name <<< "$module"
    module_path="$PlanModulePath/$(echo "$module" | sed 's/\(.*\)\.\([^\.]*\)$/\1\/\2/').sh"

    if [[ -f "$module_path" ]]; then
        $SHELL "$module_path" "${arguments[@]}"
    else
        echo "Module $module not found at $module_path"
        return 1
    fi
}

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
echo "Author:      SilverLPs"
echo "Version:     0.1"
echo "Git:         https://github.com/SilverLPs/BisonBackup"
echo
echo "###################################################"
echo
echo "RUNTIME INFO"
echo
echo "Host:        $(uname -n)"
echo "OS:          $(get_os_name)"
echo "Kernel:      $(uname -sr)"
echo "Path:        $(pwd)"
echo "Shell:       $SHELL"
echo "Time:        $(date +\%Y\%m\%d)-$(date +\%H\%M\%S)"
echo "User:        $(whoami)"
echo
echo "###################################################"
echo
load_plan "$1"
echo "PLAN INFO"
echo
echo "Name:        $PlanName"
echo "Location:    $ini_file"
echo "Path:        $PlanPath"
echo "Module Path: $PlanModulePath"
echo
echo "###################################################"
#$SHELL "/home/localadmin_silver/scripts/bisonbackup.general/command.sh"
while IFS= read -r line; do
	if [[ $line =~ ^\[.*\]$ && $line != "[Plan]" ]]; then
		task_name=$(echo "$line" | sed 's/\[\(.*\)\]/\1/')
		echo
		echo "$(date +\%Y\%m\%d)-$(date +\%H\%M\%S) - Running task: $task_name"
		echo
		process_task "$task_name"
		cd "$PlanPath"
		echo
		echo "###################################################"
	fi
done < "$ini_file"
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
