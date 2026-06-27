{pkgs, ...}: {
  programs = {
    chromium = {
      enable = true;
      package = pkgs.brave;
      commandLineArgs = ["--enable-features=TouchpadOverscrollHistoryNavigation"];
      extensions = [
        {id = "dbepggeogbaibhgnhhndojpepiihcmeb";} # vimium
        {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # dark-reader
        {id = "mnjggcdmjocbbbhaepdhchncahnbgone";} # sponsorblock
        {id = "njdfdhgcmkocbgbhcioffdbicglldapd";} # LocalCDN
        {id = "icallnadddjmdinamnolclfjanhfoafe";} # FastForward
        {id = "fkagelmloambgokoeokbpihmgpkbgbfm";} # Indie Wiki Buddy
        {id = "ghmbeldphafepmbegfdlkpapadhbakde";} # Proton Pass
        {id = "jinjaccalgkegednnccohejagnlnfdag";} # Violentmonkey
      ];
    };
  };
}
