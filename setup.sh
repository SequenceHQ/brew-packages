#!/bin/bash

#
# Reference script: https://github.com/kandji-inc/support/blob/master/Scripts/InstallHomebrew.sh
#

mostCommonUser=$(/usr/bin/last -t console | /usr/bin/awk '!/_mbsetupuser|root|wtmp/' | /usr/bin/cut -d" " -f1 | /usr/bin/uniq -c | /usr/bin/sort -nr | /usr/bin/head -n1 | /usr/bin/grep -o '[a-zA-Z].*')
brew_path="$(/usr/bin/find /usr/local/bin /opt -maxdepth 3 -name brew)"

if [ -z "$brew_path" ]; then
    # If brew_path returns empty
    echo "Brew is not yet installed - will try again later"
    exit 0 # exit cleanly as this is a possible outcome
fi

if [ "${mostCommonUser}" = "" ]; then
    echo "There is no common user other than root or _mbsetupuser... try again later"
    exit 0
fi

echo "${mostCommonUser} is the most common console user... installing homebrew as this user"

# Set environment variables
export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
BREW_INSTALL_LOG="$(mktemp)"

# Verify the TargetUser is valid
if /usr/bin/dscl . -read "/Users/${mostCommonUser}" >/dev/null 2>&1; then
    /bin/echo "Validated ${mostCommonUser}"
else
    /bin/echo "Specified user \"${mostCommonUser}\" is invalid"
    exit 1
fi

# Check for missing PATH
get_path_cmd=$(/usr/bin/su - "${mostCommonUser}" -c "${brew_path} doctor 2>&1 | /usr/bin/grep 'export PATH=' | /usr/bin/tail -1")

# Add Homebrew's "bin" to target user PATH
if [ -n "${get_path_cmd}" ]; then
    /usr/bin/su - "${mostCommonUser}" -c "${get_path_cmd}"
fi


echo "Running Brew update..."
/usr/bin/su - "${mostCommonUser}" -c "${brew_path} update --force"

echo "Running Brew upgrade..."
/usr/bin/su - "${mostCommonUser}" -c "${brew_path} upgrade"

echo "Running Brew cleanup..."
/usr/bin/su - "${mostCommonUser}" -c "${brew_path} cleanup"

echo "Running Brew doctor..."
/usr/bin/su - "${mostCommonUser}" -c "${brew_path} doctor"

echo "Installing casks packages..."
sudo -u $mostCommonUser $brew_path tap homebrew/cask
sudo -u $mostCommonUser $brew_path install --cask authy
sudo -u $mostCommonUser $brew_path install --cask google-cloud-sdk


echo "Installing dev packages..."
sudo -u $mostCommonUser $brew_path install coreutils jq yamllint adr-tools pre-commit watch

echo "Installing SRE packages..."
sudo -u $mostCommonUser $brew_path install terraform terragrunt

echo "Installing Kubernetes packages..."
sudo -u $mostCommonUser $brew_path install kubectl kubectx helm stern

if [[ -f "/Users/${mostCommonUser}/.zshrc" ]]; then
  cat /Users/${mostCommonUser}/.zshrc | uniq > /Users/${mostCommonUser}/.zshrc.clean && mv /Users/${mostCommonUser}/.zshrc.clean /Users/${mostCommonUser}/.zshrc
  echo "Trimmed ~/.zshrc"
fi
