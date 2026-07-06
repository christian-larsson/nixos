{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/default.nix
    inputs.hyprland.nixosModules.default
  ];

  # ── Bootloader ────────────────────────────────────────────────────────────────
  boot.loader = {
    systemd-boot.enable      = true;
    efi.canTouchEfiVariables = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Restrict /boot to root-only to prevent random seed exposure
  fileSystems."/boot".options = [ "umask=0077" ];

  # ── Networking ────────────────────────────────────────────────────────────────
  networking.hostName          = "thinkpad-x1";
  networking.networkmanager.enable = true;

  # ── Locale / Time ─────────────────────────────────────────────────────────────
  time.timeZone    = "Europe/Stockholm";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT    = "sv_SE.UTF-8";
    LC_MONETARY       = "sv_SE.UTF-8";
    LC_NUMERIC        = "sv_SE.UTF-8";
    LC_PAPER          = "sv_SE.UTF-8";
    LC_TELEPHONE      = "sv_SE.UTF-8";
    LC_TIME           = "sv_SE.UTF-8";
  };

  # ── User ──────────────────────────────────────────────────────────────────────
  users.users.chris = {
    isNormalUser = true;
    description  = "Christian Larsson";
    shell        = pkgs.fish;
    extraGroups  = [
      "wheel"          # sudo
      "networkmanager"
      "video"          # brightness control, VA-API
      "audio"
      "input"          # evdev (wlroots)
      "dialout"        # serial ports (/dev/ttyUSB*, /dev/ttyACM*)
      "docker"         # run docker without sudo
    ];
  };

  # ── Display / Hyprland ────────────────────────────────────────────────────────
  programs.hyprland = {
    enable   = true;
    package  = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    xwayland.enable = true;
  };

  services.displayManager.sddm = {
    enable          = true;
    wayland.enable  = true;
  };

  # ── Intel Graphics ────────────────────────────────────────────────────────────
  hardware.graphics = {
    enable      = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver  # iHD — Gen 8+ (Broadwell and newer)
      intel-vaapi-driver  # i965 — older fallback
      libvdpau-va-gl
      libva-vdpau-driver
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      intel-vaapi-driver
    ];
  };

  environment.variables.LIBVA_DRIVER_NAME = "iHD";

  # ── Audio (PipeWire) ──────────────────────────────────────────────────────────
  security.rtkit.enable = true;
  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;
    wireplumber.enable = true;
  };

  # ── Bluetooth ─────────────────────────────────────────────────────────────────
  hardware.bluetooth = {
    enable      = true;
    powerOnBoot = true;
    settings.General.Experimental = true; # battery level reporting
  };
  services.blueman.enable = true;

  # ── Fonts ──────────────────────────────────────────────────────────────────────
  # fontconfig.defaultFonts is managed by Stylix (modules/system/stylix.nix).
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
    ];
  };

  # ── XDG Portals ───────────────────────────────────────────────────────────────
  xdg.portal = {
    enable        = true;
    extraPortals  = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  # ── Shell / Programs ──────────────────────────────────────────────────────────
  programs.fish.enable = true;

  programs.gnupg.agent = {
    enable           = true;
    enableSSHSupport = true;
  };

  security.polkit.enable = true;

  # ── Minimal system packages (user packages go in home-manager) ────────────────
  environment.systemPackages = with pkgs; [
    wget curl git vim pciutils usbutils lshw htop
  ];

  # ── Nix ───────────────────────────────────────────────────────────────────────
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store   = true;
    trusted-users         = [ "root" "chris" ];
    substituters = [
      "https://cache.nixos.org"
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
      "https://stylix.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCUSeBo="
      "stylix.cachix.org-1:zbRFVjCH5KbhW/dKj8O/pjqbVBIo/LO8E/JpSXQVXEA="
    ];
  };

  nix.gc = {
    automatic = true;
    dates     = "weekly";
    options   = "--delete-older-than 14d";
  };

  system.stateVersion = "26.05"; # do NOT change after install
}
