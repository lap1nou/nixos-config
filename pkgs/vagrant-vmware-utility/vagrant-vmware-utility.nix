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

    # I'm using a login shell in the "ExecStart", because the patched binary is calling binary without absolute path, 
    # so paths in the binary rely on $PATH env variable, if we are not using a login shell, the service can't find the binary "vmware-vmx" for example.

    postInstall = ''
        mkdir -p $out/lib/systemd/system
        cat << EOF > $out/lib/systemd/system/vagrant-vmware-utility.service
            [Unit]
            Description=vagrant-vmware-utility

            [Service]
            Type=simple
            User=root
            Group=root
            Restart=on-failure
            ExecStart=${pkgs.bash}/bin/bash -lc '$out/bin/vagrant-vmware-utility api'

            [Install]
            WantedBy=multi-user.target
        EOF
        chmod 0644 $out/lib/systemd/system/vagrant-vmware-utility.service
    '';
}