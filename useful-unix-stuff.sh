#!/usr/bin/env sh

# Get IP address (Ethernet 0):
/sbin/ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'

# Get IP address (All interfaces):
/sbin/ifconfig | grep -B1 "inet addr" | awk '{ if ( $1 == "inet" ) { print $2 } else if ( $2 == "Link" ) { printf "%s:" ,$1 } }' | awk -F: '{ print $1 ": " $3 }'

# Run the last command as root
sudo !!

# Resize EC2 root volume to actual disk size
sudo resize2fs /dev/xvda1

# Start HTTPD at boot (CentOS)
sudo chkconfig --levels 345 httpd on

# Dump database to remote server using pipe (MySQL)
mysqldump -u <user> -p<password> <database> | mysql --host=<server> --user=<user> --password=<password> <database>

# Read textfile backwards, opposite of "more"
less <file>

# Get User-Agents from nginx logfile
cat <file> | grep "GET" | awk -F'"' '{print $6}' | cut -d' ' -f1 | grep -E '^[[:alnum:]]' | sort | uniq -c | sort -rn

# Get CPU info
grep "model name" /proc/cpuinfo

# Get number of CPUs
grep processor /proc/cpuinfo | wc -l

# Get total memory (in MB)
awk '/MemTotal/ {printf( "%.2fMB\n", $2 / 1024 )}' /proc/meminfo

# Get files over 50MB
find <path> -type f -size +50000k -exec ls -lh {} \; | awk '{ print $9 ": " $5 }'

# Find file by name and ignore errors
find / -name "<name>" 2> /dev/null

# Find files containing string
grep -Ril "<string>" ./

# Download all files listed in urls.txt
xargs -n 1 curl -O < urls.txt

# Bandwidth trottling, enabling 150kB/s on port 80
sudo ipfw pipe 1 config bw 15KByte/s
sudo ipfw add 1 pipe 1 src-port 80

# Bandwidth trottling, enabling
sudo ipfw delete 1

# When "sudo npm" fails on CentOS EC2
sudo ln -s /usr/local/bin/node /usr/bin/node
sudo ln -s /usr/local/lib/node /usr/lib/node
sudo ln -s /usr/local/bin/npm /usr/bin/npm
sudo ln -s /usr/local/bin/node-waf /usr/bin/node-waf

# ~/.ssh/config example (easily SSH to host with "ssh example")
# Host example
# Hostname 111.222.333.444
# User ec2-user
# IdentityFile ~/.ssh/example.pem

# SSH copy from remote host to local (<example> is the Host in ~/.ssh/config)
scp example:/some/path/on/remove/server/file.ext localfile.ext

# Last 100 most used commands
history | sed "s/^[0-9 ]*//" | sed "s/ *| */\n/g" | awk '{print $1}' | sort | uniq -c | sort -rn | head -n 100

# Determine directory where this script is running from (1)
cd ${0%/*}

# Determine directory where this script is running from (2)
script_dir=$(dirname $(echo $0 | sed -e "s,^\([^/]\),$(pwd)/\1,"))

# Clear console in Node.js (*nix)
console.log('\033[2J');

# Send UDP message to a specific host and port using NetCat
nc -u <ip> <port> <<< '<message>'

# 1. OpenCV: Compile with C++11
# 2. OpenCV: Build
CC=clang CXX=clang++ CFLAGS='-m64' CXXFLAGS='-std=c++0x -stdlib=libc++ -m64 -Wno-c++11-narrowing' cmake -G "Unix Makefiles" -D CMAKE_INSTALL_PREFIX=/Users/<username>/Library/Developer/opencv/ -D WITH_QUICKTIME=OFF -D BUILD_EXAMPLES=OFF -D BUILD_NEW_PYTHON_SUPPORT=OFF -D WITH_CARBON=OFF -D CMAKE_OSX_ARCHITECTURES=x86_64 -D BUILD_PERF_TESTS=OFF -D BUILD_SHARED_LIBS=OFF -D BUILD_opencv_legacy=NO ..
make -j8

# 1. Compile Boost C++ library with C++11 (as static)
# 2. Compile Boost C++ library with C++11 (as static)
./bootstrap.sh --with-toolset=clang
./b2 toolset=clang cxxflags="-std=c++11 -stdlib=libc++" linkflags="-stdlib=libc++" link=static

# Just because it's funny
alias please='sudo'

# List all files installed by package (CentOS)
rpm -ql <package>

# Search for filename containing "options" installed by package "pptpd" (CentOS)
rpm -ql pptpd | grep options

# Connect to VPN service (OSX) ref: http://superuser.com/questions/358513/start-configured-vpn-from-command-line-osx
scutil --nc start <name_of_service> --user <vpn_username> --password <vpn_password>

# ---------------------------- OSX SPECIFIC HACKS BELOW ----------------------------

# Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Enable subpixel font rendering on non-Apple LCDs"
defaults write NSGlobalDomain AppleFontSmoothing -int 2

# Enable the 2D Dock"
defaults write com.apple.dock no-glass -bool true

# Automatically hide and show the Dock
# defaults write com.apple.dock autohide -bool true
# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Enable iTunes track notifications in the Dock
defaults write com.apple.dock itunes-notifications -bool true

# Disable menu bar transparency
defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false

# Show remaining battery time; hide percentage
# defaults write com.apple.menuextra.battery ShowPercent -string "NO"
defaults write com.apple.menuextra.battery ShowTime -string "YES"

# # Always show scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "Auto"

# Allow quitting Finder via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Disable window animations and Get Info animations in Finder
defaults write com.apple.finder DisableAllAnimations -bool true

# Show all filename extensions in Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Use current directory as default search scope in Finder
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Show Path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Show Status bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Enable highlight hover effect for the grid view of a stack (Dock)
defaults write com.apple.dock mouse-over-hilte-stack -bool true

# Enable spring loading for all Dock items
defaults write enable-spring-load-actions-on-all-items -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Display ASCII control characters using caret notation in standard text views
# Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 0.02

# Set a shorter Delay until key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 12

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Disable opening and closing window animations
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

# Enable AirDrop over Ethernet and on unsupported Macs running Lion
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Disable disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Increase window resize speed for Cocoa applications
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Show item info below desktop icons
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

# Enable snap-to-grid for desktop icons
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Empty Trash securely by default
defaults write com.apple.finder EmptyTrashSecurely -bool true

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Enable tap to click (Trackpad)
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Map bottom right Trackpad corner to right-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true

# Disable Safari’s thumbnail cache for History and Top Sites
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

# Enable Safari’s debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Make Safari’s search banners default to Contains instead of Starts With
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

# Remove useless icons from Safari’s bookmarks bar
defaults write com.apple.Safari ProxiesInBookmarksBar "()"

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

# Disable the Ping sidebar in iTunes
defaults write com.apple.iTunes disablePingSidebar -bool true

# Disable all the other Ping stuff in iTunes
defaults write com.apple.iTunes disablePing -bool true

# Make ⌘ + F focus the search input in iTunes
defaults write com.apple.iTunes NSUserKeyEquivalents -dict-add "Target Search Field" "@F"

# Disable send and reply animations in Mail.app
# defaults write com.apple.Mail DisableReplyAnimations -bool true
defaults write com.apple.Mail DisableSendAnimations -bool true

# Disable Resume system-wide
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

# Disable the “reopen windows when logging back in” option
# This works, although the checkbox will still appear to be checked.
defaults write com.apple.loginwindow TALLogoutSavesState -bool false
defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false

# Enable Dashboard dev mode (allows keeping widgets on the desktop)
defaults write com.apple.dashboard devmode -bool true

# Reset Launchpad
[ -e ~/Library/Application\ Support/Dock/*.db ] && rm ~/Library/Application\ Support/Dock/*.db

# Show the ~/Library folder
chflags nohidden ~/Library

# Disable local Time Machine backups
hash tmutil &> /dev/null && sudo tmutil disablelocal

# Remove Dropbox’s green checkmark icons in Finder
file=/Applications/Dropbox.app/Contents/Resources/check.icns
[ -e "$file" ] && mv -f "$file" "$file.bak"
unset file

# Kill affected applications
for app in Safari Finder Dock Mail SystemUIServer; do killall "$app" >/dev/null 2>&1; done