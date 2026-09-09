{ lib
, stdenv
, src
, version
, cmake
, fftw
, glm
, libGL
, libevdev
, libpulseaudio
, luajit
, makeWrapper
, mpv
, ninja
, nlohmann_json
, pkg-config
, python3
, sol2
, wayland
, wayland-protocols
, wayland-scanner
}:

# Upstream ships a flake, but it builds against its own pinned nixpkgs and its
# license makes nixpkgs treat it as unfree, which cannot be waived from the
# outside of that flake. Building it here instead keeps it on our nixpkgs and
# lets the host's allowUnfree apply.
stdenv.mkDerivation {
  pname = "shader-desk";
  inherit src version;

  nativeBuildInputs = [
    cmake
    makeWrapper
    ninja
    pkg-config
    python3
    wayland-scanner
  ];

  buildInputs = [
    fftw
    glm
    libGL
    libevdev
    libpulseaudio
    luajit
    mpv
    nlohmann_json
    sol2
    wayland
    wayland-protocols
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_AUDIO_DAEMON" true)
    (lib.cmakeBool "BUILD_EVDEV_DAEMON" true)
    (lib.cmakeBool "ENABLE_PROFILING" false)
  ];

  # EGL/GLES drivers and the video plugin's libmpv are dlopen'd, so they have
  # to be on the library path rather than in the RPATH.
  postInstall = ''
    for program in interactive-wallpaper shader-desk-run; do
      wrapProgram "$out/bin/$program" \
        --prefix LD_LIBRARY_PATH : "/run/opengl-driver/lib:/run/opengl-driver-32/lib:${
          lib.makeLibraryPath [ libGL mpv wayland ]
        }"
    done
  '';

  meta = {
    description = "Interactive Wayland wallpaper engine driven by GLES shaders";
    homepage = "https://github.com/KMartianov/shader-desk";
    # The engine is MPL-2.0, the bundled shaders and scenes are CC BY-NC-SA 4.0
    license = with lib.licenses; [ mpl20 cc-by-nc-sa-40 ];
    mainProgram = "shader-desk-run";
    platforms = lib.platforms.linux;
  };
}
