{ config, ... }:

{
  sops.secrets.context7_api_key = { };
  programs.mcp = {
    enable = true;
    servers = {
      terraform = {
        command = "podman";
        args = [
          "run"
          "-i"
          "--rm"
          "hashicorp/terraform-mcp-server"
        ];
      };
      context7 = {
        command = "npx";
        args = [
          "-y"
          "@upstream/context7-mcp"
        ];
        env.CONTEXT7_API_KEY = {
          file = config.sops.secrets.context7_api_key.path;
        };
      };
    };
  };
}