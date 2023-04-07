#!/usr/bin/env bash

# Assigning user variables
gpu_type=$(lspci)
release_type=$(cat /usr/lib/os-releases)

echo -ne "[Adding User Repos]"
if grep -E "NVIDIA|GeForce" <<<"${gpu_type}"; then
    if grep -E "tumbleweed" <<<"${release_type}"; then
        zypper addrepo --refresh https://download.nvidia.com/opensuse/tumbleweed NVIDIA
    elif grep -E "Leap" <<<"${release_type}"; then
        zypper addrepo --refresh "https://download.nvidia.com/opensuse/leap/$releasever" NVIDIA
    fi
    select opt in G04 G05 G06; do
        case $opt in
            G04)
                zypper install --auto-agree-with-licenses --no-confirm x11-video-nvidiaG04 x11-video-nvidiaG04-32bit nvidia-glG04
                ;;
            G05)
                zypper install --auto-agree-with-licenses --no-confirm x11-video-nvidiaG05 x11-video-nvidiaG05-32bit nvidia-glG05
                ;;
            G06)
                zypper install --auto-agree-with-licenses --no-confirm x11-video-nvidiaG06 x11-video-nvidiaG06-32bit nvidia-glG06
                ;;
            quit)
                break
                ;;
            *) ;;
        esac
    done
    nvidia-xconfig
elif lspci | grep 'VGA' | grep -E "Radeon|AMD"; then
    zypper install --no-confirm xf86-video-amdgpu
elif grep -E "Integrated Graphics Controller" <<<${gpu_type}; then
    zypper in --no-confirm xf86-video-intel intel-vaapi-driver intel-opencl
elif grep -E "Intel Corporation UHD" <<<${gpu_type}; then
    zypper in --no-confirm xf86-video-intel intel-vaapi-driver intel-opencl
fi

while true; do
    read -p "Please enter username: " username
    if [[ "${username,,}" =~ ^[a-z_]([a-z0-9_-]{0,31}|[a-z0-9_-]{0,30}\$)$ ]]; then
        hostnamectl set-hostname "${username}"
        break
    fi
    echo "Incorrect username."
done
