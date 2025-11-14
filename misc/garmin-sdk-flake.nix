{
  description = "Garmin Connect IQ SDK";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    ,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            permittedInsecurePackages = [
              "libsoup-2.74.3"
            ];
          };
        };
      in
      {
        packages.default = pkgs.stdenv.mkDerivation rec {
          pname = "garmin-connect-iq-sdk";
          version = "8.2.2";

          src = pkgs.fetchurl {
            url = "https://developer.garmin.com/downloads/connect-iq/sdk-manager/connectiq-sdk-manager-linux.zip";
            hash = "sha256-ieYrO/pvBZrBPxM5/JlXrC2lQlXUtdkTNWON5gVZbyQ=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.unzip
            pkgs.makeWrapper
          ];

          buildInputs = [
            # Core libraries
            pkgs.zlib # libz.so.1
            pkgs.curl # libcurl.so.4
            pkgs.libsecret # libsecret-1.so.0
            pkgs.expat # libexpat.so.1

            # GUI libraries
            pkgs.gtk3 # libgtk-3.so.0, libgdk-3.so.0, brings in glib, gobject, etc.
            pkgs.webkitgtk_4_0 # libwebkit2gtk-4.0.so.37, libjavascriptcoregtk-4.0.so.18
            pkgs.libsoup_2_4 # libsoup-2.4.so.1

            # Graphics libraries
            pkgs.cairo # libcairo.so.2
            pkgs.pango # libpango-1.0.so.0, libpangocairo-1.0.so.0, libpangoft2-1.0.so.0
            pkgs.gdk-pixbuf # libgdk_pixbuf-2.0.so.0
            pkgs.atk # libatk-1.0.so.0

            # Font/image libraries
            pkgs.freetype # libfreetype.so.6
            pkgs.fontconfig # libfontconfig.so.1
            pkgs.libpng # libpng16.so.16
            pkgs.libjpeg8 # libjpeg.so.8

            # X11 libraries
            pkgs.xorg.libX11 # libX11.so.6
            pkgs.xorg.libXext # libXext.so.6
            pkgs.xorg.libSM # libSM.so.6
            pkgs.xorg.libXxf86vm # libXxf86vm.so.1
            pkgs.libxkbcommon # libxkbcommon.so.0

            # C++ runtime (for libstdc++.so.6, libgcc_s.so.1)
            pkgs.stdenv.cc.cc.lib
          ];

          sourceRoot = ".";

          installPhase = ''
            runHook preInstall
            mkdir -p $out
            cp -r * $out/
            runHook postInstall
          '';

          postInstall = ''
            wrapProgram $out/bin/sdkmanager \
              --set GIO_MODULE_DIR ${pkgs.glib-networking}/lib/gio/modules
          '';

          meta = with pkgs.lib; {
            homepage = "https://developer.garmin.com/connect-iq/sdk/";
            description = "Garmin Connect IQ SDK";
            platforms = platforms.linux;
          };
        };

        packages.garmin-connect-iq-sdk = self.packages.${system}.default;
      }
    );
}
