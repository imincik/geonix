![Build and populate cache](https://github.com/imincik/geonix/workflows/Build%20and%20populate%20cache/badge.svg)
[![Cachix Cache](https://img.shields.io/badge/cachix-geonix-blue.svg)](https://geonix.cachix.org)

# Geonix - geospatial environment for Nix

## Packages

For a list of maintained packages see [pkgs directory](pkgs/) or search for packages
published to [Geonix NUR.](https://nur.nix-community.org/repos/geonix/)


## Usage

### Install and configure Nix

* Install Nix on non-NixOS Linux (Ubuntu, Fedora, ...)
```
sh <(curl -L https://nixos.org/nix/install) --daemon
```

* Enable new Nix command and Nix Flakes
```
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
```

* Add current user to Nix trusted users group
```
echo "trusted-users = $USER" | sudo tee -a /etc/nix/nix.conf
```

* Restart Nix daemon
```
sudo systemctl restart nix-daemon.service
```

_For Nix installation on Mac or Windows (WSL2) see
[Install Nix documentation](https://nix.dev/tutorials/install-nix#install-nix) ._

### This Flake content

* Show this Flake content
```
nix flake show                                      # from local git checkout


nix flake show github:imincik/geonix                # from GitHub
```


### Run applications without installation

* Launch latest stable QGIS version
```
nix run .#qgis                                      # from local git checkout

nix run github:imincik/geonix#qgis                  # from GitHub
```

* Launch QGIS LTR version
```
nix run .#qgis-ltr                                  # from local git checkout

nix run github:imincik/geonix#qgis-ltr              # from GitHub
```

### Install applications permanently

* Install latest stable QGIS version
```
nix profile install .#qgis                          # from local git checkout

nix profile install github:imincik/geonix#qgis      # from GitHub
```

* Install QGIS LTR version
```
nix profile install .#qgis-ltr                      # from local git checkout

nix profile install github:imincik/geonix#qgis-ltr  # from GitHub
```

### Geonix shell

* Enter shell containing Geonix applications, CLI tools and Python interpreter
```
nix develop                                         # from local git checkout

nix develop github:imincik/geonix                   # from GitHub
```

* Launch QGIS
```
[geonix] > qgis
```

* Launch gdalinfo
```
[geonix] > gdalinfo --version

GDAL 3.6.0.1, released 2022/11/16
```

* Launch Python interpreter
```
[geonix] > python -c "import fiona; print(fiona.supported_drivers)"

{'DXF': 'rw', 'CSV': 'raw', 'OpenFileGDB': 'r', 'ESRIJSON': 'r', ... }
```


## Development

* Build single package
```
nix build .#<PACKAGE>
```

* Build all packages
```
nix build .#all-packages
```

* Run package passthru tests
```
nix-build -A packages.x86_64-linux.<PACKAGE>.passthru.tests
```

_To re-build already built package or to re-run already succeeded tests use
`--check` switch._

* Explore package store path content
```
nix path-info -rsSh .#<PACKAGE> | sort -nk3
```

* Explain package dependencies
```
nix why-depends .#<PACKAGE> .#<DEPENDENCY>
```
