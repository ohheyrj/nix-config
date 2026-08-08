{ ... }:

{
  programs.mcp = {
    enable = true;
    servers = {
      terraform = {
        command = "podman";
        args = [
          "run",
          "-i",
          "--rm",
          "hashicorp/terraform-mcp-server"
        ];
      };
    };
  };
}