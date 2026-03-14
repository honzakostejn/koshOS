{ inputs, ... }: {
  perSystem = { pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        azure-cli
        azure-storage-azcopy
        jq
      ];
    };
  };
}
