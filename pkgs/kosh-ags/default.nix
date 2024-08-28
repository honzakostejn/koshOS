{
  inputs,
  stdenv,
  pkgs,
  bun,
  rsync,
  bash,
  dart-sass,
}:

stdenv.mkDerivation (
let
  ags = inputs.ags.packages.${pkgs.system}.default.override {
    extraPackages = import ./dependencies.nix {inherit pkgs;};
    buildTypes = true;
  };
  packageName = "kosh-ags";

in {
  name = packageName;

  src = ./.;
  
  preBuild = ''
    echo "Linking ags types to local types"
    ln -s ${ags}/share/com.github.Aylur.ags/types ./types
  '';

  buildPhase = ''
    runHook preBuild

    echo "Building with bun"
    bun build ./config.ts --outdir ./build/js --external 'resource://*' --external 'gi://*'

    echo "Building with sass"
    sass --trace style/style.scss style.css

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    echo "Creating output dir"
    mkdir $out

    echo "Copying most files using rsync"
    rsync -avm --del \
      --exclude '*.js' \
      --exclude '*.ts' \
      --exclude '*.scss' \
      --exclude '*.nix' \
      --exclude 'tsconfig.json' \
      --exclude 'build' \
      --exclude 'types' \
      ./ $out/

    echo "Copying js"
    cp -r ./build/js/* $out

    echo "Creating convience output script"
    mkdir $out/bin
    cat > $out/bin/kosh-ags << EOF
    #!${bash}/bin/bash
    ${ags}/bin/ags -q && ${ags}/bin/ags -c $out/config.js
    EOF

    runHook postInstall
  '';

  postInstall = ''
    echo "Making convience output script executable"
    chmod +x $out/bin/${packageName}
  '';

  buildInputs = [bun rsync dart-sass ags];
})