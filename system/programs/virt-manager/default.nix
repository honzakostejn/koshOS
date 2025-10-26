{ lib
, pkgs
, config
, ...
}:
{
  options = {
    koshos.programs.virt-manager = {
      enable = lib.mkEnableOption "Virtual Machine Manager" // {
        default = true;
      };
    };
  };

  config = lib.mkIf config.koshos.programs.virt-manager.enable {
    programs.virt-manager.enable = true;

    # https://github.com/winapps-org/winapps/blob/main/docs/libvirt.md#prerequisites
    users.groups.kvm.members = [ "honzakostejn" ];
    users.groups.libvirtd.members = [ "honzakostejn" ];

    # Enable libvirtd for VM management
    virtualisation.libvirtd = {
      enable = true;
      qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
    };

    # Enable SPICE USB redirection
    virtualisation.spiceUSBRedirection.enable = true;
  };
}
