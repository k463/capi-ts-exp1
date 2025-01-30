# workaround for arrterian/nix-env-selector#87 (nix-env-selector does not work with flakes)
# https://github.com/arrterian/nix-env-selector/issues/87
# credit: https://github.com/arrterian/nix-env-selector/issues/87#issuecomment-2079805980

(builtins.getFlake ("git+file://" + toString ./.)).devShells.${builtins.currentSystem}.default
