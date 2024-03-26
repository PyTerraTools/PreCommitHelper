# PreCommitHelper

PreCommitHelper is a bash script designed to automate the setup of pre-commit hooks for Python and Terraform projects. It configures pre-commit hooks for popular linting and formatting tools such as isort, black, flake8, and several Terraform-specific hooks. The script also includes a feature to run pre-commit checks on files modified since the last commit.

## Installation and Usage

### Installation

Clone the repository to your local machine:

```git clone https://github.com/PyTerraTools/PreCommitHelper.git```

Navigate to the directory containing the script:

```cd yourrepository```

Make the script executable:

```chmod +x pre-commit-helper.sh```

### Usage

 To run the script, navigate to the root directory of the repository you want to check, and execute the following command:

```/path/to/pre-commit-helper.sh```

Replace /path/to/ with the actual path to the pre-commit-helper.sh script.
The script will create a file named ```.pre-commit-config.yaml``` in the directory from which you execute it. You can commit this script to version control if you wish to share it more broadly.

Optional: Execute the Script Like a Command

If you want to be able to run the script from anywhere without having to specify the path to the script, you can add it to /usr/local/bin, which is included in the PATH by default on most Unix-like operating systems.

 Create a symbolic link to the script in /usr/local/bin:

```sudo cp /path/to/pre-commit-helper.sh /usr/local/bin/pre-commit-helper```

Replace /path/to/ with the actual path to the pre-commit-helper.sh script. You can also use a symbolic link if you prefer.

Now you can run the script like a command:

```pre-commit-helper```

## Dependencies

The script installs the following dependencies:

make
build-essential
libssl-dev
zlib1g-dev
libbz2-dev
libreadline-dev
libsqlite3-dev
wget
curl
llvm
libncurses5-dev
libncursesw5-dev
xz-utils
tk-dev
libffi-dev
liblzma-dev
python3
python3-openssl
git

The script will check if these dependencies are installed and install them if they're not.

## Pre-commit Hooks

The script configures the following pre-commit hooks:

- isort: A Python utility / library to sort imports.
- black: The uncompromising Python code formatter.
- flake8: A tool for style guide enforcement.
- terraform_fmt: Rewrites all Terraform configuration files to a canonical format.
- terraform_docs: Inserts input and output documentation into Terraform modules.
- terraform_validate: Validates all Terraform configuration files.
- terraform_tflint: Validates all Terraform configuration files with TFLint.
- trailing-whitespace: Trims trailing whitespace.
- check-case-conflict: Checks for files with names that would conflict on a case-insensitive filesystem like Windows.
- end-of-file-fixer: Ensures that a file is either empty, or ends with one newline.
- mixed-line-ending: Replaces or checks mixed line ending.
- requirements-txt-fixer: Sorts entries in requirements.txt.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
