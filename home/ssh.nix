_:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*.amazonaws.com" = {
        User = "ec2-user";
        SetEnv = {
          TERM = "xterm-256color";
        };
      };
      "10.1.2.5 openclaw.int.ldn.casa" = {
        User = "openclaw";
        SetEnv = {
          TERM = "xterm-256color";
        };
      };
      "10.1.2.4 openclaw-host.int.ldn.casa" = {
        SetEnv = {
          TERM = "xterm-256color";
        };
      };
      "droplet.madebyrichard.shop droplet.thecuriouslondoner.co.uk 68.183.253.100" = {
        User = "root";
        SetEnv = {
          TERM = "xterm-256color";
        };
      };
    };
  };
}
