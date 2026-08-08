{ ... }:

{
  services.podman = {
    enable = true;
    useDefaultMachine = true;
  };

  imports = [
    ./containers/mcp.nix
  ];
}