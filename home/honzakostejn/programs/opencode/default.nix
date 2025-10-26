{ lib
, inputs
, pkgs
, config
, ...
}:
{
  options = {
    koshos.home.honzakostejn.programs.opencode = {
      enable = lib.mkEnableOption "opencode - AI coding agent, built for the terminal." // {
        default = true;
      };
    };
  };

  config = lib.mkIf config.koshos.home.honzakostejn.programs.opencode.enable {
    programs.opencode = {
      enable = true;
      # package = pkgs.opencode.overrideAttrs (finalAttrs: previousAttrs: {
      #   version = "0.4.26";
      #   src = inputs.opencode;

      #   node_modules = previousAttrs.node_modules.overrideAttrs (nmPrev: {
      #     outputHash = "sha256-ql4qcMtuaRwSVVma3OeKkc9tXhe21PWMMko3W3JgpB0=";
      #   });

      #   nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [
      #     pkgs.makeBinaryWrapper
      #   ];

      #   tui = previousAttrs.tui.overrideAttrs (tuiPrev: {
      #     src = inputs.opencode;
      #     modRoot = "packages/tui";
      #     vendorHash = "sha256-jINbGug/SPGBjsXNsC9X2r5TwvrOl5PJDL+lrOQP69Q=";
      #   });

      #   buildPhase = ''
      #     runHook preBuild

      #     bun build \
      #       --define OPENCODE_TUI_PATH="'${finalAttrs.tui}/bin/tui'" \
      #       --define OPENCODE_VERSION="'${finalAttrs.version}'" \
      #       --compile \
      #       --target=bun-linux-x64 \
      #       --outfile=opencode \
      #       ./packages/opencode/src/index.ts \

      #     runHook postBuild
      #   '';

      #   # Execution of commands using bash-tool fail on linux with
      #   # Error [ERR_DLOPEN_FAILED]: libstdc++.so.6: cannot open shared object file: No such
      #   # file or directory
      #   # Thus, we add libstdc++.so.6 manually to LD_LIBRARY_PATH
      #   postFixup = ''
      #     wrapProgram $out/bin/opencode \
      #       --set LD_LIBRARY_PATH "${lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib ]}"
      #   '';
      # });
      settings = {
        theme = "tokyonight";
        agent = {
          # http://opencode.ai/docs/agents/#options
        };
        formatter = {
          # http://opencode.ai/docs/formatters/#custom-formatters
          nix = {
            extensions = [ ".nix" ];
            command = [
              "${pkgs.nixfmt-rfc-style}/bin/nixfmt"
              "$FILE"
            ];
          };
        };
      };
    };

    xdg.configFile."opencode" = {
      source = ./.;
      recursive = true;
    };
  };
}
