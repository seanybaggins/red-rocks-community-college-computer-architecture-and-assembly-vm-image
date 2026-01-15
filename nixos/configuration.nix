{
  pkgs,
  ...
}:

{
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  imports = [
  ];

  # Boot configuration - use GRUB for VirtualBox compatibility
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  # Enable emulation for ARM v7 binaries
  boot.binfmt.emulatedSystems = [ "armv7l-linux" ];

  # Enable VirtualBox guest additions
  virtualisation.virtualbox.guest.enable = true;

  # Configure disk size for VirtualBox OVA
  virtualisation.diskSize = 10240; # 10GB disk

  # Networking
  networking.hostName = "student-vm";
  networking.networkmanager.enable = true;

  # Time zone
  time.timeZone = "America/Denver";

  # Internationalization
  i18n.defaultLocale = "en_US.UTF-8";

  # Desktop environment
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.xfce.enable = true;
    # VirtualBox graphics driver
    videoDrivers = [
      "vmware"
      "vesa"
      "modesetting"
    ];
  };

  # Audio
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User configuration
  users.users.student = {
    isNormalUser = true;
    description = "Student User";
    extraGroups = [
      "networkmanager"
      "wheel"
      "vboxsf"
      "dialout"
      "plugdev"
    ];
    initialPassword = "student";
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "student";
  };

  # System packages
  environment.systemPackages = with pkgs; [
    xfce.xfce4-terminal
    gcc
    pkgsCross.armv7l-hf-multiplatform.buildPackages.gcc
  ];

  # Enable SSH for remote access
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  # Firewall
  #networking.firewall.enable = true;
  #networking.firewall.allowedTCPPorts = [ 22 ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "25.11";

}
