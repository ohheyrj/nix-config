{ pkgs, lib, ... }:

{
  programs.uv.enable = true;

  home.activation.uvToolInstall = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.uv}/bin/uv tool install graphifyy
  '';
}
