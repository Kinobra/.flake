{ stdenv, lib, fetchurl }: # , variants ? [ "Black" "Blue" "Red" "White" ]

with lib;

stdenv.mkDerivation rec {
  name = "${package-name}-${version}";
  package-name = "google-cursor-black";
  version = "2.0.0";

  src = fetchurl {
    url = "https://github.com/ful1e5/Google_Cursor/releases/download/v${version}/GoogleDot-Black.tar.gz";
    sha256 = "1qq0pnpzqi582f8d6rixiyc594chmz2dp354l4k8dh7smg64vn7r";
  };

  installPhase = ''
    mkdir -p $out/share/icons/${package-name}
    cp -R {cursors,cursor.theme,index.theme} $out/share/icons/${package-name}/
  '';

  meta = {
    description = "GoogleDot-Black cursor theme";
    homepage = https://github.com/ful1e5/Google_Cursor;
    platforms = platforms.all;
    license = licenses.gpl3;
    maintainers = with maintainers; [ sntx ];
  };
}
