{
  pkgs,
  config,
  ...
}:
{

  # home.packages = with pkgs; [
  #   nyxt
  # ];

  programs = {
    chromium = {
      enable = true;
      package = pkgs.brave;
      commandLineArgs = ["--enable-features=TouchpadOverscrollHistoryNavigation"];
      extensions = [
        {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # ublock origin
        {id = "dbepggeogbaibhgnhhndojpepiihcmeb";} # vimium
        {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # dark-reader
        {id = "lljedihjnnjjefafchaljkhbpfhfkdic";} # jiffy reader
        {id = "mnjggcdmjocbbbhaepdhchncahnbgone";} # sponsorblock
      ];
    };


  };
}
