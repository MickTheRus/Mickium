{
  pkgs,
  config,
  lib,
  ...
}: {
  hardware = {
    opengl = let
      fn = oa: {
        nativeBuildInputs = oa.nativeBuildInputs ++ [pkgs.glslang];
        mesonFlags = oa.mesonFlags ++ ["-Dvulkan-layers=device-select,overlay"];
        #       patches = oa.patches ++ [ ./mesa-vulkan-layer-nvidia.patch ]; See below
        postInstall =
          oa.postInstall
          + ''
            mv $out/lib/libVkLayer* $drivers/lib

            #Device Select layer
            layer=VkLayer_MESA_device_select
            substituteInPlace $drivers/share/vulkan/implicit_layer.d/''${layer}.json \
              --replace "lib''${layer}" "$drivers/lib/lib''${layer}"

            #Overlay layer
            layer=VkLayer_MESA_overlay
            substituteInPlace $drivers/share/vulkan/explicit_layer.d/''${layer}.json \
              --replace "lib''${layer}" "$drivers/lib/lib''${layer}"
          '';
      };
    in
      with pkgs; {
        enable = true;
        package = (mesa.overrideAttrs fn).drivers;
      };
  };
}
