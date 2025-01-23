# BisonBackup

BisonBackup is a lightweight and modular backup script framework. It acts as a script runner that executes specified subscripts (called *Modules*) based on a user-defined configuration file (referred to as a *Backup Plan*).

---

## Key Features

- **Modular Design:** Integrate existing or your own script *Modules* and run them with customized parameters.
- **Backup Plans:** Centralized `.ini` configuration files to manage *Tasks* and their execution parameters.
- **Dynamic Task Execution:** Automatically runs tasks with specified modules and paths.
- **Full Portability:** BisonBackup is entirely written in pure Bash, requiring no additional dependencies. It runs seamlessly on any system that supports the Bash shell or its syntax.
- **Simplicity by Design:** Transform any Bash script into a flexible module that receives parameters in a standardized argument format, as defined by the *Backup Plan*.

---

## Installation

1. Clone the repository:
   git clone https://github.com/SilverLPs/BisonBackup.git
   cd BisonBackup

2. Make the script executable:
   chmod +x bisonbackup.sh

3. Create your own Backup Plan (see the **Backup Plan** sections for details). Ensure the specified *Modules* are stored in the directory specified by "ModulePath" in your *Backup Plan*.

---

## Usage

### Basic Command

Run BisonBackup with your Backup Plan:
bisonbackup.sh <path-to-backup-plan.ini>

### Output

When executed, BisonBackup provides detailed runtime information, including:

- Hostname
- Operating System and Kernel
- Current Directory
- Execution Timestamp
- User Information
- Plan Details (name, location, and associated paths)

It is advisable to redirect all output to a text file and retain it for future reference and analysis.

---

## Backup Plan Structure

A *Backup Plan* is a simple `.ini` file that defines the *Tasks* and *Modules* to be executed. It is structured into multiple sections:

### Plan Section
The Plan Section specifies the overall configuration for the *Backup Plan*. This section must appear at the top of the configuration file and is identified by `[Plan]` in brackets. Each *Backup Plan* requires a unique Plan Section.

- **Name**: The name of the Backup Plan.
- **Path**: The working directory for tasks. If omitted, defaults to the current directory.
- **ModulePath**: The directory where task modules are located.

### Task Sections
Each task is defined in its own section, specifying the module and parameters required for execution. Task sections begin with a unique custom name enclosed in brackets, which must not be reused elsewhere in the Backup Plan.

- **TaskModule**: The module to be executed for the task. This is a required parameter.
- **TaskPath**: (Optional) The directory where the task should be executed. If specified, BisonBackup will temporarily switch to this directory during the task's execution.
- **ARGUMENTS**: Parameters written in uppercase (e.g., `ARGUMENTS`) are custom arguments passed to the specified module. For details on a module’s parameters, refer to its documentation.

#### Example
[Plan]
Name=Demo Plan
Path=/home/demouser/
ModulePath=/home/demouser/.local/bisonbackup/modules/

[Hello world]
TaskModule=bisonbackup.general.command
TaskPath=
COMMAND="echo hello world test 123"

[Run example script]
TaskModule=bisonbackup.general.script
TaskPath=/home/demouser/myscripts/
SCRIPT="mycommand.sh"
ARGUMENTS="--myparameter=examplevalue"

---

## Adding Modules

*Modules* are external scripts that are organized into *Packages* and located in the directory specified by the `ModulePath` parameter in the *Backup Plan*. A package name usually combines the source of the *Package* and the packages theme (e.g., `bisonbackup.general`). Modules are executed by BisonBackup based on the task configuration defined in the Backup Plan.

### Example Module Directory Structure
/home/demouser/.local/bisonbackup/modules/bisonbackup.general
├── command.sh
├── script.sh
├── filelist.sh
└── remove.sh

### Module Naming Convention
In the Backup Plan, modules are referenced using a hierarchical naming convention:  

**Example:** `bisonbackup.general.filelist`

-   **bisonbackup**: Indicates the source of the package.
-   **general**: Refers to the package containing a group of related modules.
-   **filelist**: Specifies the module itself, corresponding to the script `filelist.sh`.

### Module Execution
Each *Module* is executed using the parameters specified in its corresponding task section, passed as arguments in the format `SOURCE=/home/demouser/filepath DESTINATION=/home/demouser/filepath2`.

### Available Module Packages
BisonBackup's functionality is entirely provided by its *Modules*. Several "official" *Packages* are available as part of the BisonBackup project:

- **bisonbackup.general:** 
General-purpose modules for simple operations, such as running commands or handling file operations.
- **bisonbackup.networktransfer:**
Modules for transferring files and directories over various network protocols.
- **bisonbackup.gitutils:**
Modules for interacting with Git repositories.
- **bisonbackup.borg:**
Modules designed for handling backups using BorgBackup.

These packages are currently incomplete and contain only the specific modules I have needed so far. Additional modules may be added in the future if the project evolves.

In addition to these official packages, I have also developed some personal module packages that are not part of the official BisonBackup project:

- **silverlps.email:**
Modules for handling email operations.
- **silverlps.discord:**
Modules for interacting with the Discord platform.

For more details on the available module packages, refer to their respective documentation.

---

## Logging

BisonBackup outputs logs directly to the console, including:
- Start and end timestamps for tasks
- Task names
- Task output
- Errors (e.g., missing modules or paths)

---

## Contributions and Issues

Contributions and issues reports are generally welcome! Please feel free to submit issues or pull requests on the [GitHub repository](https://github.com/SilverLPs/BisonBackup). However, please be aware that this project is primarily developed for my personal purposes. While I share it in case it might be useful to others, I may not always be able to respond promptly to contributions or issue reports.

---

## License and Disclaimer

BisonBackup is licensed under the MIT License. See [LICENSE](LICENSE) for more details.

### Disclaimer of Warranty and Responsibility

BisonBackup is a private project developed in my spare time. It is provided "as is" without any warranty of any kind, either expressed or implied. I cannot offer any guarantees regarding its functionality, security, or suitability for a specific purpose. Anyone using the software does so entirely at their own risk.

### Use at Your Own Risk

Users are encouraged to thoroughly review the scripts and modules before using them. The software, including BisonBackup itself and all associated modules, is intended for technically proficient users who understand the potential risks and can assess whether the software meets their requirements. If you are not confident in your technical ability to understand or review the code, I strongly advise against using this software.

### Recommendations for Technical Users

- Carefully review the provided scripts and configurations before running them.
- Test the software in a safe environment before applying it to critical data or systems. 
- Use the software only if you are comfortable with its functionality and limitations.

This project is not intended for non-technical users, and I explicitly discourage anyone without a strong technical understanding from using this software.
