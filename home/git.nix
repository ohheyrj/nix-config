_:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "Richard Annand";
      user.email = "richard@ohheyrj.co.uk";
      init.defaultBranch = "main";
      ghq.root = "/Users/richard/repos";
      pull.ff = "only";
      push.autoSetupRemote = true;
      core.editor = "nvim";
    };
    lfs = {
      enable = true;
    };
    signing = {
      format = "openpgp";
      signer = "gpg";
      signByDefault = true;
    };
  };
}
