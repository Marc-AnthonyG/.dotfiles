#!/bin/sh

export ICON_COG=󰒓 # system settings, system information, tinkertool
export ICON_CHART=󱕍 # activity monitor, btop
export ICON_LOCK=󰌾

export ICONS_SPACE=(󰎤 󰎧 󰎪 󰎭 󰎱 󰎳 󰎶)

export ICON_APP=󰣆 # fallback app
export ICON_TERM=󰆍 # fallback terminal app, terminal, warp, iterm2
export ICON_PACKAGE=󰏓 # brew
export ICON_DEV=󰅨 # nvim, xcode, vscode
export ICON_FILE=󰉋 # ranger, finder
export ICON_GIT=󰊢 # lazygit
export ICON_LIST=󱃔 # taskwarrior, taskwarrior-tui, reminders, onenote
export ICON_SCREENSAVOR=󱄄 # unimatrix, pipe.sh

export ICON_MAIL=󰇮 # mail, outlook
export ICON_CALC=󰪚 # calculator, numi
export ICON_MAP=󰆋 # maps, find my
export ICON_MICROPHONE=󰍬 # voice memos
export ICON_CHAT=󰍩 # messages, slack, teams, discord, telegram
export ICON_VIDEOCHAT=󰍫 # facetime, zoom, webex
export ICON_NOTE=󱞎 # notes, textedit, stickies, word, bat
export ICON_CAMERA=󰄀 # photo booth
export ICON_WEB=󰇧 # safari, beam, duckduckgo, arc, edge, chrome, firefox
export ICON_HOMEAUTOMATION=󱉑 # home
export ICON_MUSIC=󰎄 # music, spotify
export ICON_PODCAST=󰦔 # podcasts
export ICON_PLAY=󱉺 # tv, quicktime, vlc
export ICON_BOOK=󰂿 # books
export ICON_BOOKINFO=󱁯 # font book, dictionary
export ICON_PREVIEW=󰋲 # screenshot, preview
export ICON_PASSKEY=󰷡 # 1password
export ICON_DOWNLOAD=󱑢 # progressive downloader, transmission
export ICON_CAST=󱒃 # airflow
export ICON_TABLE=󰓫 # excel
export ICON_PRESENT=󰈩 # powerpoint
export ICON_CLOUD=󰅧 # onedrive
export ICON_PEN=󰏬 # curve
export ICON_REMOTEDESKTOP=󰢹 # vmware, utm

case "$1" in
  "Terminal" | "Warp" | "iTerm2")
    RESULT=$ICON_TERM
    if grep -q "btop" <<< $2; then
      RESULT=$ICON_CHART
    fi
    if grep -q "brew" <<< $2; then
      RESULT=$ICON_PACKAGE
    fi
    if grep -q "nvim" <<< $2; then
      RESULT=$ICON_DEV
    fi
    if grep -q "ranger" <<< $2; then
      RESULT=$ICON_FILE
    fi
    if grep -q "lazygit" <<< $2; then
      RESULT=$ICON_GIT
    fi
    if grep -q "taskwarrior-tui" <<< $2; then
      RESULT=$ICON_LIST
    fi
    if grep -q "unimatrix\|pipes.sh" <<< $2; then
      RESULT=$ICON_SCREENSAVOR
    fi
    if grep -q "bat" <<< $2; then
      RESULT=$ICON_NOTE
    fi
    if grep -q "tty-clock" <<< $2; then
      RESULT=$ICON_CLOCK
    fi
    ;;
  "Finder")
    RESULT=$ICON_FILE
    ;;
  "Weather")
    RESULT=$ICON_WEATHER
    ;;
  "Clock")
    RESULT=$ICON_CLOCK
    ;;
  "Mail" | "Microsoft Outlook")
    RESULT=$ICON_MAIL
    ;;
  "Calendar")
    RESULT=$ICON_CALENDAR
    ;;
  "Calculator" | "Numi")
    RESULT=$ICON_CALC
    ;;
  "Maps" | "Find My")
    RESULT=$ICON_MAP
    ;;
  "Voice Memos")
    RESULT=$ICON_MICROPHONE
    ;;
  "Messages" | "Slack" | "Microsoft Teams" | "Discord" | "Telegram")
    RESULT=$ICON_CHAT
    ;;
  "FaceTime" | "zoom.us" | "Webex")
    RESULT=$ICON_VIDEOCHAT
    ;;
  "Notes" | "TextEdit" | "Stickies" | "Microsoft Word")
    RESULT=$ICON_NOTE
    ;;
  "Reminders" | "Microsoft OneNote")
    RESULT=$ICON_LIST
    ;;
  "Photo Booth")
    RESULT=$ICON_CAMERA
    ;;
  "Safari" | "Beam" | "DuckDuckGo" | "Arc" | "Microsoft Edge" | "Google Chrome" | "Firefox")
    RESULT=$ICON_WEB
    ;;
  "System Settings" | "System Information" | "TinkerTool")
    RESULT=$ICON_COG
    ;;
  "HOME")
    RESULT=$ICON_HOMEAUTOMATION
    ;;
  "Music" | "Spotify")
    RESULT=$ICON_MUSIC
    ;;
  "Podcasts")
    RESULT=$ICON_PODCAST
    ;;
  "TV" | "QuickTime Player" | "VLC")
    RESULT=$ICON_PLAY
    ;;
  "Books")
    RESULT=$ICON_BOOK
    ;;
  "Xcode" | "Code" | "Neovide")
    RESULT=$ICON_DEV
    ;;
  "Font Book" | "Dictionary")
    RESULT=$ICON_BOOKINFO
    ;;
  "Activity Monitor")
    RESULT=$ICON_CHART
    ;;
  "Disk Utility")
    RESULT=$ICON_DISK
    ;;
  "Screenshot" | "Preview")
    RESULT=$ICON_PREVIEW
    ;;
  "1Password")
    RESULT=$ICON_PASSKEY
    ;;
  "NordVPN")
    RESULT=$ICON_VPN
    ;;
  "Progressive Downloaded" | "Transmission")
    RESULT=$ICON_DOWNLOAD
    ;;
  "Airflow")
    RESULT=$ICON_CAST
    ;;
  "Microsoft Excel")
    RESULT=$ICON_TABLE
    ;;
  "Microsoft PowerPoint")
    RESULT=$ICON_PRESENT
    ;;
  "OneDrive")
    RESULT=$ICON_CLOUD
    ;;
  "Curve")
    RESULT=$ICON_PEN
    ;;
  "VMware Fusion" | "UTM")
    RESULT=$ICON_REMOTEDESKTOP
    ;;
  *)
    RESULT=$ICON_APP
    ;;
esac

echo $RESULT

