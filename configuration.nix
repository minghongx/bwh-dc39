{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  services.sing-box.enable = true;
  services.sing-box.settings = {
    log.level = "debug";
  };

  networking = {
    hostName = "bwh-dc39";
    domain = "minghongxu.name";

    interfaces.ens18.useDHCP = true;
    interfaces.ens19.useDHCP = true; # TODO: what is ens19 used for?

    firewall = {
      enable = false;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
  };

  environment.systemPackages = with pkgs; [
  ];

  programs.git.enable = true;
  programs.git.config = {
    user.name  = "Minghong Xu";
    user.email = "minghong@minghongxu.name";
    init.defaultBranch = "canon";
    pull.rebase = true;
    credential.helper = "store";
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

  time.timeZone = "Asia/Tokyo";

  # https://unix.stackexchange.com/questions/62316/
  i18n.defaultLocale = "en_GB.UTF-8"; # English, UK, UTF-8 encoding

  boot = {
    initrd.availableKernelModules = [ "ata_piix" "sd_mod" ];
    initrd.kernelModules = [ ];

    kernelModules = [ ];
    extraModulePackages = [ ];

    loader.grub = {
      enable = true;
      device = "/dev/sda";
    };
  };

  console = {
    font = "ter-i20b"; # https://files.ax86.net/terminus-ttf/README.Terminus.txt
    keyMap = "us";
    packages = [ pkgs.terminus_font ];
  };

  # TODO: use nix-community/disko for declarative disk partitioning and formatting
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/332d0a2f-e746-494c-9068-f89cd5f756f5";
      fsType = "ext4";
    };
  swapDevices =
    [ { device = "/dev/disk/by-uuid/9971938e-638b-4488-9866-081783054998"; }
    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "24.11";
}
