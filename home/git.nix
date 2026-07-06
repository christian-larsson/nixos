{ ... }:

{
  programs.git = {
    enable = true;

    delta.enable = true;

    settings = {
      user = {
        name  = "Christian Larsson";
        email = "christianalarsson@gmail.com";
      };
      core = {
        editor   = "zed --wait";
        autocrlf = false;
        fileMode = true;
      };
      init.defaultBranch    = "main";
      pull.rebase           = true;
      push.autoSetupRemote  = true;
      merge.conflictstyle   = "diff3";
      diff.colorMoved       = "default";

      alias = {
        st  = "status -sb";
        lg  = "log --oneline --graph --decorate --all";
        co  = "checkout";
        br  = "branch";
        cp  = "cherry-pick";
        rb  = "rebase";
      };
    };

    ignores = [
      ".DS_Store"
      "*.swp"
      ".direnv/"
      ".env"
      "result"
    ];
  };

  programs.delta = {
    enable  = true;
    options = {
      navigate     = true;
      dark         = true;
      line-numbers = true;
      syntax-theme = "Catppuccin Mocha";
      side-by-side = false;
    };
  };
}
