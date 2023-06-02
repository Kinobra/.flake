{ stdenv, lib, fetchurl }: # , variants ? [ "Black" "Blue" "Red" "White" ]

with lib;

stdenv.mkDerivation rec {
  name = "${package-name}-${version}";
  package-name = "google-cursor-white";
  version = "2.0.0";

  src = fetchurl {
    url = "https://github.com/ful1e5/Google_Cursor/releases/download/v${version}/GoogleDot-White.tar.gz";
    sha256 = "1c6dndiqgj4xnhkkpz3fp4yr6qdz148rhwpw07pgv5ymss096dnd";
  };

  installPhase = ''
    mkdir -p $out/share/icons/${package-name}
    cp -R {cursors,cursor.theme,index.theme} $out/share/icons/${package-name}/
  '';

  meta = {
    description = "GoogleDot-White cursor theme";
    homepage = "https://github.com/ful1e5/Google_Cursor";
    platforms = platforms.all;
    license = licenses.gpl3;
    maintainers = with maintainers; [ sntx ];
  };
}
