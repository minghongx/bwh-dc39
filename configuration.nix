{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  services.sing-box = {
    enable = true;
    settings = {
      log.level = "debug";
    };
  };

  networking = {
    hostName = "bwh-dc39";
    domain = "minghongxu.name";

    networkmanager.enable = true; # TODO: configure network interfaces manually

    firewall = {
      enable = false;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
  };

  environment.systemPackages = with pkgs; [
  ];

  programs.git = {
    enable = true;
    config = {
      user.name  = "Minghong Xu";
      user.email = "minghong@minghongxu.name";
      init.defaultBranch = "main";
      pull.rebase = true;
      credential.helper = "store";
    };
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGaBqZ+yDtH2ttPWK32R07c50+a/QdshOfv++EDKfv5m minghongxu@thinkbook"
  ];

  services.qemuGuest.enable = true;

  time.timeZone = "Asia/Tokyo";

  # https://unix.stackexchange.com/questions/62316/
  i18n.defaultLocale = "en_GB.UTF-8"; # English, UK, UTF-8 encoding

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  console = {
    font = "ter-i20b"; # https://files.ax86.net/terminus-ttf/README.Terminus.txt
    keyMap = "us";
    packages = [ pkgs.terminus_font ];
  };

  system.stateVersion = "24.11";
}
