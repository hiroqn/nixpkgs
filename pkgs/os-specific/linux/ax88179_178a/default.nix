{ stdenv, fetchzip, kernel }:

stdenv.mkDerivation rec {
  name = "ax88179_178a-${version}-${kernel.version}";
  version = "1.20.0";
  src = fetchzip {
    url = "https://www.asix.com.tw/en/support/download/file/120";
    sha256 = "sha256:0ja33pshmfw1h31rh27k3gqqm8xc5cyargdli7g7mghn6hqb58da";
    postFetch = ''
      unpackDir="$TMPDIR/unpack"
      mkdir "$unpackDir"
      cd "$unpackDir"
      renamed="$TMPDIR/driver.tar.bz2"
      mv "$downloadedFile" "$renamed"
      unpackFile "$renamed"
      fn=$(cd "$unpackDir" && echo *)
      if [ -f "$unpackDir/$fn" ]; then
        mkdir $out
      fi
      mv "$unpackDir/$fn" "$out"
      chmod -R a-w "$out"
      chmod u+w "$out"
    '';
  };
  hardeningDisable = [ "pic" ];
  makeFlags = [ "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;
  installPhase = ''
    binDir="$out/lib/modules/${kernel.modDirVersion}/misc"
    mkdir -p "$binDir"
    cp ax88179_178a.ko "$binDir"
  '';
  dontStrip = true;
  dontPatchELF = true;
  noAuditTmpdir = true;
  meta = {
    description = "Kernel module driver for AX88179";
    homepage = "https://www.asix.com.tw/en/product/USBEthernet/Super-Speed_USB_Ethernet/AX88179";
    #license = stdenv.lib.licenses.unfreeRedistributable; TODO confirm
    platforms = stdenv.lib.platforms.linux;
  };
}
