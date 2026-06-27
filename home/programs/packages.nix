{
  inputs,
  pkgs,
  ...
}: let
  py = pkgs.python3Packages;

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
    blender
    bolt-launcher
    inputs.claude-desktop.packages.${pkgs.system}.claude-desktop
    codex
    inkscape
    kdePackages.kdeconnect-kde
    kitty
    krita
    meshcore-cli
    meshtastic
    qbittorrent
    thunar
    thunar-volman
    ventoy
    yazi
    libnotify
    xdg-utils
  ];
}
