{ ... }: {
  flake.nixosModules.programs-virt-manager = { pkgs, ... }: {
    programs.virt-manager.enable = true;

    # https://github.com/winapps-org/winapps/blob/main/docs/libvirt.md#prerequisites
    users.groups.kvm.members = [ "honzakostejn" ];
    users.groups.libvirtd.members = [ "honzakostejn" ];

    virtualisation.libvirtd = {
      enable = true;
      qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
    };

    virtualisation.spiceUSBRedirection.enable = true;
  };
}
