{
  inputs,
  pkgs,
  ...
}: let
  py = pkgs.python3Packages;

  yaac = pkgs.stdenvNoCC.mkDerivation {
    pname = "yaac";
    version = "2026-06-10";

    src = pkgs.fetchurl {
      url = "https://downloads.sourceforge.net/project/yetanotheraprsc/YAAC.zip";
      hash = "sha256-5kw/yl+kZvCK9JwhBMpgTBTWwcnWgXcUCN0Hx9tQB+Y=";
    };

    nativeBuildInputs = with pkgs; [
      makeWrapper
      unzip
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/share/yaac" "$out/bin"
      unzip -q "$src" -d "$out/share/yaac"
      yaac_jar="$(find "$out/share/yaac" -name YAAC.jar -print -quit)"

      makeWrapper ${pkgs.jre}/bin/java "$out/bin/yaac" \
        --run "cd $(dirname "$yaac_jar")" \
        --add-flags "-jar $yaac_jar"

      runHook postInstall
    '';
  };

  meshcore = py.buildPythonPackage rec {
    pname = "meshcore";
    version = "2.3.7";
    pyproject = true;

    src = py.fetchPypi {
      inherit pname version;
      hash = "sha256-JnEH4JqW99DWP0vbFALQM6ckuq3Zyb7Pm3GkWBcPYLs=";
    };

    build-system = [py.hatchling];

    dependencies = with py; [
      bleak
      pycayennelpp
      pyserial-asyncio-fast
      pycryptodome
    ];

    pythonImportsCheck = ["meshcore"];
  };

  meshcore-cli = py.buildPythonPackage {
    pname = "meshcore-cli";
    version = "1.5.7";
    pyproject = true;

    src = inputs.meshcore-cli;

    build-system = with py; [
      hatchling
      setuptools
      wheel
    ];

    dependencies = with py; [
      meshcore
      bleak
      click
      prompt-toolkit
      pyserial
      requests
      pycryptodome
    ];

    doCheck = false;
  };
in {
  home.packages = with pkgs; [
    # misc
    ax25-tools
    blender
    bolt-launcher
    direwolf
    inputs.claude-desktop.packages.${pkgs.system}.claude-desktop
    codex
    cutecom
    gpsbabel
    inkscape
    jetbrains.rider
    kdePackages.kdeconnect-kde
    kitty
    krita
    meshcore-cli
    meshtastic
    prismlauncher
    qbittorrent
    scrcpy
    thunar
    thunar-volman
    ventoy
    yazi
    yaac
    libnotify
    xdg-utils
  ];
}
