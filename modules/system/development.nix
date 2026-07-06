{ ... }:

{
  # Docker daemon — backs the `cross` cargo tool for containerized
  # cross-compilation to Raspberry Pi targets (matches CI/CD & Ubuntu users).
  # The user is added to the "docker" group in hosts/thinkpad-x1/default.nix.
  virtualisation.docker.enable = true;

  # nix-ld: provides an FHS-style dynamic loader so prebuilt binaries work —
  # manylinux Python wheels (uv/pip), downloaded toolchains, vendor tools, etc.
  programs.nix-ld.enable = true;

  # Allow running AppImages directly (e.g. the INAV Configurator desktop app).
  # Alternatively use the INAV web configurator in Chrome via WebSerial — no install.
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
