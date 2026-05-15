{ pkgs, ... }: {
  home.packages = with pkgs; [
    dotnet-sdk_10
  ];

  home.sessionVariables = {
    DOTNET_ROOT = "${pkgs.dotnet-sdk_10}/share/dotnet";
  };

  home.sessionPath = [
    "$HOME/.dotnet/tools"
  ];
}
