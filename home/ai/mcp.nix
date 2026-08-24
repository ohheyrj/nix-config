{ config, pkgs, ... }:

{
  sops.secrets = {
    context7_api_key = { };
    github_personal_access_token = { };
    n8n_mcp_token = { };
  };
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
      mcp-nixos = {
        command = "podman";
        args = [
          "run"
          "--rm"
          "-i"
          "ghcr.io/utensils/mcp-nixos"
        ];
      };
      n8n = {
        url = "https://n8n.int.ldn.casa/mcp-server/http";
        headersHelper = toString (
          pkgs.writeShellScript "n8n-mcp-headers" ''
            token=$(cat ${config.sops.secrets.n8n_mcp_token.path}) || exit 1
            exec ${pkgs.jq}/bin/jq -n \
              --arg token "$token" \
              '{ Authorization: ("Bearer " + $token) }'
          ''
        );
      };
      n8n-kapa = {
        url = "https://n8n.mcp.kapa.ai";
      };
      obsidian-second-brain = {
        command = "/etc/profiles/per-user/richard/bin/obsidian-mcp";
        args = [
          "/Users/richard/Obsidian Vaults/second-brain"
        ];
      };
    };
  };
}
