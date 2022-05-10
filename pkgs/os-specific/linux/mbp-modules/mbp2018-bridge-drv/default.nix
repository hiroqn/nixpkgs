{ lib, stdenv, kernel, fetchFromGitHub, }:

stdenv.mkDerivation rec {
  pname = "mbp2018-bridge-drv";
  version = "2020-01-31";

  src = fetchFromGitHub {
    owner = "t2linux";
    repo = "apple-bce-drv";
    rev = "f93c6566f98b3c95677de8010f7445fa19f75091";
    sha256 = "sha256-5jvfDSa7tHp6z+E+RKIalNiLpsku1RNnKoJV2Ps8288=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = kernel.makeFlags;

  buildPhase = ''
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
      -j$NIX_BUILD_CORES M=$(pwd) modules $makeFlags
  '';

  installPhase = ''
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build  \
      INSTALL_MOD_PATH=$out M=$(pwd) modules_install $makeFlags
  '';

  meta = with lib; {
    description = "A driver for MacBook models 2018 and newer, which makes the keyboard, mouse and audio output work.";
    longDescription = ''
      A driver for MacBook models 2018 and newer, implementing the VHCI (required for mouse/keyboard/etc.) and audio functionality.
    '';
    homepage = "https://github.com/MCMrARM/mbp2018-bridge-drv";
    license = lib.licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = [ lib.maintainers.hlolli ];
    broken = kernel.kernelOlder "5.4";
  };
}
