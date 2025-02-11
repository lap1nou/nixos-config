{ lib, pkgs, ... }:
pkgs.buildGoModule rec {
    name = "vagrant-vmware-utility";
    version = "1.0.23";

    src = pkgs.fetchFromGitHub {
        owner = "hashicorp";
        repo = "vagrant-vmware-desktop";
        rev = "utility-v${version}";
        sha256 = "sha256-D/2sNU7iyzTKD+/JlauDl2cBaKGoRrSYynlU3+iQYyo=";
    };

    patches = [ ./fix_paths.patch ];

    vendorHash = "sha256-Z/5rruRoar2HcFpeZCMo/YM6yo1pL+0oUJ4AKT4YKa0=";

    nativeBuildInputs = [ pkgs.installShellFiles ];
}