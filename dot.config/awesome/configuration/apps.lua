return {
  -- List of apps to start by default on some actions
  default = {
    terminal = 'alacritty',
    rofi = 'rofi',
    lock = 'i3lock',
    quake = 'terminator',
    screenshot = 'flameshot screen -p ~/Pictures',
    region_screenshot = 'flameshot gui -p ~/Pictures',
    delayed_screenshot = 'flameshot screen -p ~/Pictures -d 5000',
    browser = 'brave',
    editor = 'gedit', -- gui text editor
    social = 'discord',
    files = 'nautilus',
  },
}
