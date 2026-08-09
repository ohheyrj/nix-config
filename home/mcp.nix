{ config, ... }:

{
  sops.secrets.context7_api_key = { };
  sops.secrets.github_personal_access_token = { };
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
          "@upstash/context7-mcp"
        ];
        env.CONTEXT7_API_KEY = {
          file = config.sops.secrets.context7_api_key.path;
        };
      };
      github = {
        command = "podman";
        args = [
          "run"
          "-i"
          "--rm"
          "-e"
          "GITHUB_PERSONAL_ACCESS_TOKEN"
          "ghcr.io/github/github-mcp-server"
        ];
        env.GITHUB_PERSONAL_ACCESS_TOKEN = {
          file = config.sops.secrets.github_personal_access_token.path;
        };
      };
    };
  };
}

