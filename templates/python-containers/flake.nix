{
  description = "Python container images";

  nixConfig.extra-substituters = [ "https://geonix.cachix.org" ];
  nixConfig.extra-trusted-public-keys = [ "geonix.cachix.org-1:iyhIXkDLYLXbMhL3X3qOLBtRF8HEyAbhPXjjPeYsCl0=" ];

  nixConfig.bash-prompt = "\\[\\033[1m\\][geonix]\\[\\033\[m\\]\\040\\w >\\040";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
  inputs.geonix.url = "github:imincik/geonix";
  inputs.utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, geonix, utils }:
    utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;

          # add Geonix overlay with packages under geonix namespace (pkgs.geonix.<PACKAGE>)
          overlays = [ geonix.overlays.${system} ];
        };

        # Choose your Python version here.
        # Supported versions:
        # * python37
        # * python38
        # * python39
        # * python310
        # * python311
        py = pkgs.python3;

        geonixPython = py.withPackages (p: [

          # Geonix packages
          pkgs.geonix.python-fiona
          pkgs.geonix.python-gdal
          pkgs.geonix.python-geopandas
          pkgs.geonix.python-owslib
          pkgs.geonix.python-pyproj
          pkgs.geonix.python-rasterio
          pkgs.geonix.python-shapely

          # Search for additional Python packages from Nixpkgs:
          # $ nix search nixpkgs/nixos-22.11 "python3.*Packages.<PACKAGE>"
          # and add them in following format below:

          # pkgs.<PYTHON-VERSION>.pkgs.<PACKAGE>
        ]);

        geonixJupyter = py.withPackages (p: [

          # Geonix packages
          pkgs.geonix.python-fiona
          pkgs.geonix.python-gdal
          pkgs.geonix.python-geopandas
          pkgs.geonix.python-owslib
          pkgs.geonix.python-pyproj
          pkgs.geonix.python-rasterio
          pkgs.geonix.python-shapely

          # Packages from Nixpkgs
          pkgs.python3.pkgs.ipython
          pkgs.python3.pkgs.jupyter

          # Add additional packages here as above.
        ]);

      in
      {

        #
        ### PACKAGES ###
        #

        packages = rec {

          # See dockerTools documentation:
          # https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-dockerTools

          # Python interpreter image
          pythonImage = pkgs.dockerTools.buildLayeredImage
            {
              name = "geonix-python";
              tag = "latest";
              created = "now";
              contents = [ geonixPython ];
              config = {
                Entrypoint = [ "${geonixPython}/bin/python" ];
              };
            };

          # Jupyter notebook image
          jupyterImage = pkgs.dockerTools.buildLayeredImage
            {
              name = "geonix-jupyter";
              tag = "latest";
              created = "now";
              contents = [ geonixJupyter ];
              config = {
                Cmd = [ "${geonixJupyter}/bin/jupyter" "notebook" "--ip=0.0.0.0" "--allow-root" ];
                ExposedPorts = {
                  "8888/tcp" = { };
                };
              };
            };

          default = pythonImage;
        };
      });
}