{ pkgs, ... }:

{
  programs.antigravity-cli = {
    enable = true;
    package = pkgs.gemini-cli;

    enableMcpIntegration = true;
  };
}
