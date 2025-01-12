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
    ini_file="$(realpath "$1")"
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
                        PlanPathArg="$value"
                        ;;
                    ModulePath)
                        PlanModulePath="$(realpath "$value")"
                        ;;
                esac
            fi
        fi
    done < "$ini_file"
    if [[ -z "$PlanPathArg" ]]; then
        PlanPath=$(pwd)
    else
	PlanPath="$(realpath "$PlanPathArg")"
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
echo "$(date +\%Y\%m\%d)-$(date +\%H\%M\%S) - BisonBackup finished"
echo
