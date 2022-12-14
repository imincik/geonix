{ lib, makeWrapper, symlinkJoin
, extraPythonPackages ? (ps: [ ])
, qgis-ltr-unwrapped
}:
with lib;

symlinkJoin rec {

  inherit (qgis-ltr-unwrapped) version src;
  name = "qgis-${version}";

  paths = [ qgis-ltr-unwrapped ];

  nativeBuildInputs = [ makeWrapper qgis-ltr-unwrapped.py.pkgs.wrapPython ];

  # extend to add to the python environment of QGIS without rebuilding QGIS application.
  pythonInputs = qgis-ltr-unwrapped.pythonBuildInputs ++ (extraPythonPackages qgis-ltr-unwrapped.py.pkgs);

  postBuild = ''

    buildPythonPath "$pythonInputs"

    wrapProgram $out/bin/qgis \
      --prefix PATH : $program_PATH \
      --set PYTHONPATH $program_PYTHONPATH
  '';

  passthru.unwrapped = qgis-ltr-unwrapped;

  inherit (qgis-ltr-unwrapped) meta;
}
