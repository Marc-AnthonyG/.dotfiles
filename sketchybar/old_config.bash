##### Adding Mission Control Space Indicators #####
# Register custom event trigger by yabai
sketchybar --add event window_change


SPACE_ICONS=("1:" "2:" "3:" "4:" "5:" "6:")

for i in "${!SPACE_ICONS[@]}"
do
  sid=$(($i+1))
  sketchybar --add space space.$sid left                                 \
             --set space.$sid associated_space=$sid                      \
                              icon=${SPACE_ICONS[i]}                     \
                              background.color=0x44ffffff                \
                              background.corner_radius=5                 \
                              background.height=20                       \
                              background.drawing=off                     \
                              label="_"                                  \
                              label.font.size="18.0"                      \
                              script="$PLUGIN_DIR/space.sh"              \
                              click_script="yabai -m space --focus $sid" \
             --subscribe space.$sid window_change
done

# Unlock animation 
sketchybar --add event lock   "com.apple.screenIsLocked"   \
           --add event unlock "com.apple.screenIsUnlocked" \
                                                           \
           --add item         animator left                \
           --set animator     drawing=off                  \
                              updates=on                   \
                              script="$PLUGIN_DIR/wake.sh" \
           --subscribe        animator lock unlock



#Volume indicator
sketchybar --add item volume right --set volume \
            script="$PLUGIN_DIR/volume.sh" --subscribe volume volume_change 


#Git notifications
sketchybar --add item github.bell left \
           --set github.bell update_freq=180 icon=􀋙 label=$LOADING \
                 script="$PLUGIN_DIR/gitNotifications.sh" \
                 click_script="sketchybar --set \$NAME popup.drawing=toggle" \

