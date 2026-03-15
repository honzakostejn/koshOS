{ ... }: {
  flake.nixosModules.services-cloudflare-warp = { ... }: {
    services.cloudflare-warp.enable = true;
  };
}
