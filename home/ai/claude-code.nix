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
  };
}