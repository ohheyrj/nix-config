{ pkgs, inputs, ... }:

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