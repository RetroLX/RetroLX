# Add RetroLX logo and some alias, sourcing of $HOME/.bashrc can be added to $HOME/.profile
echo 'RetroLX'
echo 'BACK TO THE RETRO'
echo
echo "-- type 'retrolx-check-updates' to check for stable branch --"
echo "-- add 'beta' switch to check for latest arch developments  --"
echo
batocera-info 2>/dev/null
echo "OS version: $(cat /usr/share/retrolx/retrolx.version)"
echo
