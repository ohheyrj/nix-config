{ lib, ... }:

let
  files = builtins.readDir ./.;
  nixFiles = lib.filterAttrs (name: type:
    type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix"
  ) files;
in {
  imports = lib.mapAttrsToList (name: _: ./. + "/${name}") nixFiles;
}
