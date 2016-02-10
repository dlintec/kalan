sudo apt-add-repository -y ppa:teejee2008/ppa
sudo apt-get update
sudo apt-get -y install conky conky-manager

echo "-----------------------------------------------------"
echo "  I will open conky-manager for you..."
echo "  a)Select the widgets you want to appear in your desktop."
echo "    Recommended: second from top-'conky_seamod'"
echo "  b)Click the equalizer button at the top right (Applications Setting)"
echo "  c)Activate (to ON) 'Run Conky at system startup'  and click OK"
conky-manager &> /dev/null

