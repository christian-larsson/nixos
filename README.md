# nixos

NixOS flake configuration for an Intel ThinkPad X1.

Hyprland (Wayland) · Fish · Ghostty · Stylix/Catppuccin Mocha · LUKS
full-disk encryption · home-manager. Python (uv) and Rust (rust-overlay) dev
tooling.

## Layout

```
flake.nix                 inputs + nixosConfigurations.thinkpad-x1
hosts/thinkpad-x1/        system config, hardware config
modules/system/           groups, services, stylix, development (docker/nix-ld)
home/                     home-manager: hyprland, fish, git, neovim, zed, packages, stylix
docs/                     keybindings reference
```

## Fresh install

Boot the **NixOS minimal ISO** from USB.

### 1. Network

**Wired** — DHCP is automatic, nothing to do.

**Wi-Fi:** run `nmtui`, select *Activate a connection*, pick your network and enter the
password. Then verify with `ping -c1 github.com`.

### 2. Partition and encrypt

Check the disk device first — usually `/dev/nvme0n1` on the X1:

```sh
lsblk
```

Partition, encrypt, and mount:

```sh
# Partition: 512 MiB EFI + rest as LUKS
parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 512MiB
parted /dev/nvme0n1 -- set 1 esp on
parted /dev/nvme0n1 -- mkpart primary 512MiB 100%

# Format EFI
mkfs.fat -F32 -n EFI /dev/nvme0n1p1

# Encrypt root (you will set your LUKS passphrase here)
cryptsetup luksFormat /dev/nvme0n1p2
cryptsetup open /dev/nvme0n1p2 cryptroot

# Format and mount
mkfs.ext4 -L nixos /dev/mapper/cryptroot
mount /dev/mapper/cryptroot /mnt
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
```

### 3. Clone the repo and fill in the hardware config

```sh
git clone https://github.com/christian-larsson/nixos /tmp/nixos

# Detects mounted filesystems, LUKS device, kernel modules, and CPU flags
nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix \
   /tmp/nixos/hosts/thinkpad-x1/hardware-configuration.nix
```

### 4. Install

```sh
nixos-install --flake /tmp/nixos#thinkpad-x1
```

### 5. Set password and reboot

```sh
nixos-enter --root /mnt -c 'passwd chris'
reboot
```

### 6. After first boot

Clone the repo to manage the system going forward:

```sh
git clone https://github.com/christian-larsson/nixos /etc/nixos
```

Then do the two things that need real hardware to know:

- Run `hyprctl monitors` and update the monitor line in `home/hyprland.nix`
- Replace `stylix.image` in `modules/system/stylix.nix` with your wallpaper

Apply changes with `nrs` (alias for `sudo nixos-rebuild switch --flake /etc/nixos#thinkpad-x1`).

Log out and back in once so the `docker` group takes effect.

## Rebuild after changes

```sh
nrs    # sudo nixos-rebuild switch --flake /etc/nixos#thinkpad-x1
nfu    # nix flake update /etc/nixos
```

## Reference

- [Keybindings](docs/keybindings.md)
