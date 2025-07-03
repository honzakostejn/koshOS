{ lib
, config
, ...
}: {
  options = {
    koshos.services.cloudflare-warp = {
      enable = lib.mkEnableOption "Cloudflare WARP service" // { default = true; };
    };
  };

  config = lib.mkIf config.koshos.services.cloudflare-warp.enable {
    services.cloudflare-warp = {
      enable = true;
    };
  };
}
