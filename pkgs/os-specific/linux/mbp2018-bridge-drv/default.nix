{ stdenv, lib, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  pname = "mbp2018-bridge-drv-${version}-${kernel.version}";
  version = "b43fcc069da73e051072fde24af4014c9c487286";
  src = fetchFromGitHub {
    owner = "MCMrARM";
    repo = "mbp2018-bridge-drv";
    rev = version;
    sha256 = "sha256:0ac2l51ybfrvg8m36x67rsvgjqs1vwp7c89ssvbjkrcq3y4qdb53";
  };
  hardeningDisable = [ "pic" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;
  buildPhase = ''
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$PWD modules
  '';
  installPhase = ''
    binDir="$out/lib/modules/${kernel.modDirVersion}/misc"
    mkdir -p "$binDir"
    cp bce.ko "$binDir"
  '';
  dontStrip = true;
  dontPatchELF = true;
  noAuditTmpdir = true;
  meta = {
    description = "MacBook Bridge/T2 Linux Driver";
    homepage = "https://github.com/MCMrARM/mbp2018-bridge-drv";
    #license = stdenv.lib.licenses.unfreeRedistributable; TODO confirm
    platforms = stdenv.lib.platforms.linux;
  };
}
