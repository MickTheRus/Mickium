{
  config,
  pkgs,
  ...
}: let
  # The RT Systems programmers are installed by hand into this Wine prefix; see
  # "Radio programmers" in DESCRIPTION.MD for how it was built.
  prefix = "${config.xdg.dataHome}/wine-radio/rtsystems";
  wine = pkgs.wineWow64Packages.stableFull;

  # module: RadioEngine_V5.exe /m: name, dir: folder under C:\RT Systems V5,
  # ext: RT data file extension, mime: custom MIME type for that extension.
  radios = [
    {
      id = "rt-thd75";
      title = "RT Systems TH-D75";
      dir = "Kenwood\\THD75_V5";
      module = "THD75RadioData";
      exts = ["THD75" "d75"];
      mime = "application/x-rtsystems-thd75";
    }
    {
      id = "rt-dmr6x2pro";
      title = "RT Systems DMR-6X2 Pro";
      dir = "BTech\\DMR6X2_V5";
      module = "DMR6X2ProRadioData";
      exts = ["DMR6X2Pro"];
      mime = "application/x-rtsystems-dmr6x2pro";
    }
    {
      id = "rt-atd578";
      title = "RT Systems AT-D578UV";
      dir = "AnyTone\\ATD578_V5";
      module = "ATD578RadioData";
      exts = ["ATD578"];
      mime = "application/x-rtsystems-atd578";
    }
  ];

  # Opens the programmer, converting an optional file argument to a Windows path.
  launcher = radio:
    pkgs.writeShellApplication {
      name = radio.id;
      runtimeInputs = [wine];
      text = ''
        export WINEPREFIX="${prefix}"
        export WINEDEBUG=-all
        cd "$WINEPREFIX/drive_c/RT Systems V5/${builtins.replaceStrings ["\\"] ["/"] radio.dir}"
        if [ $# -gt 0 ]; then
          exec wine RadioEngine_V5.exe "/m:${radio.module}" "$(winepath -w "$1")"
        fi
        exec wine RadioEngine_V5.exe "/m:${radio.module}"
      '';
    };

  mimeXml = pkgs.writeText "rt-systems.xml" ''
    <?xml version="1.0" encoding="UTF-8"?>
    <mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
    ${builtins.concatStringsSep "\n" (map (r: ''
        <mime-type type="${r.mime}">
          <comment>${r.title} data file</comment>
      ${builtins.concatStringsSep "\n" (map (e: "    <glob pattern=\"*.${e}\" case-sensitive=\"false\"/>") r.exts)}
        </mime-type>'')
    radios)}
    </mime-info>
  '';
in {
  home.packages = map launcher radios;

  xdg = {
    dataFile."mime/packages/rt-systems.xml".source = mimeXml;

    desktopEntries = builtins.listToAttrs (map (r: {
        name = r.id;
        value = {
          name = r.title;
          comment = "Radio programming software (Wine)";
          exec = "${r.id} %f";
          icon = "applications-electronics";
          categories = ["HamRadio" "Utility"];
          mimeType = [r.mime];
        };
      })
      radios);

    mimeApps.defaultApplications = builtins.listToAttrs (map (r: {
        name = r.mime;
        value = ["${r.id}.desktop"];
      })
      radios);
  };
}
