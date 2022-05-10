{ stdenv, lib, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  pname = "macbook12-spi-driver";
  version = "fix/kernel-5.9";
  src = fetchFromGitHub {
    owner = "rado0x54";
    repo = "macbook12-spi-driver";
    rev = version;
    sha256 = "sha256:07m93gkdxkxswcnj5727yhixnz485fyg1ki7b9564vcj122nibz8";
  };
  hardeningDisable = [ "pic" ];
  makeFlags = [ "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;
#  installPhase = ''
#    binDir="$out/lib/modules/${kernel.modDirVersion}/misc"
#    mkdir -p "$binDir"
#    cp apple-ibridge.ko "$binDir"
#    cp apple-ib-tb.ko "$binDir"
#    cp apple-ib-als.ko "$binDir"
#  '';
  installPhase = ''
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build  \
      INSTALL_MOD_PATH=$out M=$(pwd) modules_install
  '';
  dontStrip = true;
  dontPatchELF = true;
  noAuditTmpdir = true;
  meta = {
    description = "Input driver for the SPI keyboard / trackpad";
    homepage = "https://github.com/roadrunner2/macbook12-spi-driver";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}
