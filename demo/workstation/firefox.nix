{
  hm.programs.firefox = {
    enable = true;

    policies = {
      Homepage.StartPage = "previous-session";
      Preferences = {
        "browser.urlbar.suggest.calculator" = true;
      };
    };
  };
}
