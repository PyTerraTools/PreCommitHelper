#!/bin/bash
# set -ex
# Function to log messages
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Function to check if a package is installed and install it if it's not
check_and_install() {
    package=$1
    if ! dpkg -l | grep -q $package; then
        log "Installing $package..."
        if ! sudo apt-get install -y $package > /dev/null; then
            log "Failed to install $package"
            exit 1
        fi
    fi
}

# Function to update package lists
update_packages() {
    log "Updating package lists..."
    if ! sudo apt-get update > /dev/null; then
        log "Failed to update package lists"
        exit 1
    fi
}

# Function to install pre-commit
install_precommit() {
    log "Installing pre-commit..."
    if ! python3 -m pip install pre-commit > /dev/null; then
        log "Failed to install pre-commit"
        exit 1
    fi
    pre-commit install > /dev/null
}

# Function to create .pre-commit-config.yaml
create_precommit_config() {
    log "Creating .pre-commit-config.yaml..."
    # Linter and formatter versions
    ISORT_VERSION="5.13.2"
    BLACK_VERSION="24.3.0"
    FLAKE8_VERSION="7.0.0"
    TERRAFORM_VERSION="v1.88.4"
    PRE_COMMIT_HOOKS_VERSION="v4.5.0"
    cat > .pre-commit-config.yaml << EOF
    default_language_version:
      python: python3.12
    default_stages:
      - pre-commit
      - pre-push
    fail_fast: false # Stop running checks after first failure
    repos:
      - repo: https://github.com/PyCQA/isort.git
        rev: $ISORT_VERSION
        hooks:
          - id: isort
            args:
                - "--profile=black"
                - "--multi-line=3"
                - "--trailing-comma"

      - repo: https://github.com/psf/black.git
        rev: $BLACK_VERSION
        hooks:
          - id: black

      - repo: https://github.com/PyCQA/flake8.git
        rev: $FLAKE8_VERSION
        hooks:
          - id: flake8
            args:
              - "--extend-ignore=E226, E722, W504, E501"
              - "--max-line-length=120"
              - "--max-complexity=10"

      - repo: https://github.com/antonbabenko/pre-commit-terraform
        rev: ${TERRAFORM_VERSION}
        hooks:
          - id: terraform_fmt
          - id: terraform_docs
          - id: terraform_validate
          - id: terraform_tflint

      - repo: https://github.com/pre-commit/pre-commit-hooks
        rev: $PRE_COMMIT_HOOKS_VERSION
        hooks:
          - id: trailing-whitespace # trims trailing whitespace.
            args: ["--markdown-linebreak-ext=md,markdown"]
          - id: check-case-conflict
          - id: end-of-file-fixer #  ensures that a file is either empty, or ends with one newline.
          - id: mixed-line-ending # replaces or checks mixed line ending.
          - id: requirements-txt-fixer #sorts entries in requirements.txt.
EOF
}

# Function to run pre-commit on modified files
run_precommit() {
    # Get a list of all modified files since the last commit
    files=$(git diff --name-only HEAD)

    # Run pre-commit on the modified files if there are any
    if [[ -n "$files" ]]; then
        log "Running pre-commit on the following files:\n$files\n\n"
        pre-commit run --files $files
    else
        log "No files have been modified since the last commit."
    fi
}

# Main script
main() {
    update_packages

    dependencies=("make" "build-essential" "libssl-dev" "zlib1g-dev" "libbz2-dev"
                  "libreadline-dev" "libsqlite3-dev" "wget" "curl" "llvm" "libncurses5-dev"
                  "libncursesw5-dev" "xz-utils" "tk-dev" "libffi-dev" "liblzma-dev" "python3" "python3-openssl" "git")

    for package in "${dependencies[@]}"; do
        check_and_install $package
    done

    install_precommit
    create_precommit_config
    run_precommit
}

main
