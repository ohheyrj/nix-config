{ inputs, ... }:

{
  programs.claude-code = {
    enable = true;
    enableMcpIntegration = true;
    plugins = [
      "${inputs.claude-plugins-official}/plugins/claude-code-setup"
      "${inputs.claude-plugins-official}/plugins/frontend-design"
      "${inputs.agent-toolkit-for-aws}/plugins/aws-core"
      "${inputs.claude-code-warp}/plugins/warp"
    ];

    # Everything below here used to live only in the real ~/.claude/settings.json.
    # Once `settings` is non-empty, home-manager fully owns that file, so anything
    # not re-declared here disappears from the live config.
    settings = {
      model = "sonnet";
      tui = "fullscreen";
      voice = {
        enabled = false;
        mode = "hold";
      };
      skipDangerousModePermissionPrompt = true;
      theme = "dark-daltonized";
      agentPushNotifEnabled = true;

      permissions = {
        allow = [
          # GitHub read operations
          "mcp__plugin_claude-code-home-manager_github__get_*"
          "mcp__plugin_claude-code-home-manager_github__list_*"
          "mcp__plugin_claude-code-home-manager_github__search_*"
          "mcp__plugin_claude-code-home-manager_github__issue_read"
          "mcp__plugin_claude-code-home-manager_github__pull_request_read"
          # Nix package/option searches
          "mcp__plugin_claude-code-home-manager_mcp-nixos__*"
          # Library/framework docs lookups
          "mcp__plugin_claude-code-home-manager_context7__*"
          # Terraform registry reads
          "mcp__plugin_claude-code-home-manager_terraform__get_*"
          "mcp__plugin_claude-code-home-manager_terraform__search_*"
          # Git inspection
          "Bash(git log*)"
          "Bash(git diff*)"
          "Bash(git status*)"
          # Web fetches
          "WebFetch(domain:github.com)"
          "WebFetch(domain:raw.githubusercontent.com)"
          "WebFetch(domain:docs.openclaw.ai)"
          "WebSearch"
          # GitHub CLI reads
          "Bash(gh run list*)"
          "Bash(gh run view*)"
          "Bash(gh run watch*)"
          "Bash(gh workflow list*)"
          "Bash(gh workflow view*)"
          # Filesystem search
          "Bash(find*)"
          "Bash(grep*)"
          # Kubernetes (read-only)
          "Bash(kubectl get*)"
          "Bash(kubectl top*)"
          "Bash(kubectl debug*)"
          "Bash(kubectl describe*)"
          "Bash(kubectl logs*)"
          # Terraform
          "Bash(terraform validate*)"
          "Bash(terraform plan*)"
          "Bash(terraform fmt*)"
          "Bash(terraform init*)"
          "Bash(terraform output*)"
          "Bash(terraform show*)"
          "Bash(terraform workspace list*)"
          "Bash(terraform workspace show*)"
        ];
      };

      # gitkraken-hooks isn't nix-managed (see docs/ note): it's written and kept
      # updated by the locally-installed GitKraken Desktop app itself, with no
      # stable upstream source to pin. Preserved manually here so taking over
      # settings.json doesn't silently disable it.
      enabledPlugins = {
        "gitkraken-hooks@gitkraken" = true;
      };
      extraKnownMarketplaces = {
        gitkraken = {
          source = {
            source = "directory";
            path = "/Users/richard/.claude/plugins/marketplaces/gitkraken";
          };
        };
      };
    };
  };
}
