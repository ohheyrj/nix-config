_:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Richard Annand";
        email = "richard@ohheyrj.co.uk";
        signingKey = "7FA00C301979455214E4294865212690666E56A5!";
      };
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
