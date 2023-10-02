{ pkgs, ... }:

{
  # Caps Lock as Escape key when pressed on its own
  environment.etc."dual-function-keys.yaml".text = ''
    MAPPINGS:
      - KEY: KEY_CAPSLOCK
        TAP: KEY_ESC
        HOLD: KEY_LEFTCTRL
      - KEY: KEY_SPACE
        TAP: KEY_SPACE
        HOLD: KEY_LEFTMETA
  '';
  services.interception-tools = {
    enable = true;
    plugins = [ pkgs.interception-tools-plugins.dual-function-keys ];
    udevmonConfig = ''
    - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys -c /etc/dual-function-keys.yaml | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
      DEVICE:
        EVENTS:
          EV_KEY: [KEY_CAPSLOCK, KEY_SPACE]
    '';
  };

  # Layout
  console.keyMap = "dvorak";
  services.xserver = {
    layout = "us";
    xkbVariant = "dvorak-alt-intl";
  };
}
