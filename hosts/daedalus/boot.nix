{
  common,
  pkgs,
  self,
  ...
}:
let
  link = drv: path: "ln -s {${drv},.}/${path}";

  script =
    name: text:
    let
      script = pkgs.writeText name ''
        #!ipxe
        ${text}
      '';
    in
    "ln -s ${script} ${name}";

  section = name: text: ''
    mkdir ${name} && pushd ${name}
    ${text}
    popd
  '';

  ipxe = pkgs.ipxe.override {
    additionalTargets = {
      "bin-x86_64-efi/ipxe.iso" = "ipxe-efi.iso";
    };
    additionalOptions = [
      "CONSOLE_CMD"
      #"CERT_CMD"
      #"DIGEST_CMD"
      #"IMAGE_COMBOOT"
      "IMAGE_TRUST_CMD"
      "IMAGE_CRYPT_CMD"
      #"IMAGE_GZIP"
      #"IMAGE_ZLIB"
      #"PARAM_CMD"
      #"PCI_CMD"
    ];
    embedScript = pkgs.writeText "autostart.ipxe" ''
      #!ipxe
      ifconf
      chain --replace https://boot.inx.moe/main.ipxe
    '';
  };
in
{
  services.nginx.virtualHosts."boot.inx.moe" = common.nginx.ssl-inx-optional // {
    locations."/" = {
      root =
        let
          lethe = self.nixosConfigurations.lethe.config.system.build;
        in
        pkgs.runCommandLocal "netboot-directory" { } ''
          mkdir $out && cd $out
          ${link ipxe "ipxe.iso"}
          ${link ipxe "ipxe-efi.iso"}

          ${script "main.ipxe" ''
            chain --replace https://boot.inx.moe/lethe/netboot.ipxe
          ''}

          ${section "lethe" ''
            ${link lethe.netboot "initrd"}
            ${link lethe.netboot "bzImage"}
            ${link lethe.netbootIpxeScript "netboot.ipxe"}
            ${script "netboot-logs.ipxe" ''
              kernel bzImage init=${lethe.toplevel}/init initrd=initrd zswap.enabled=1 zswap.max_pool_percent=50 zswap.compressor=zstd zswap.zpool=zsmalloc nohibernate loglevel=7 lsm=landlock,yama,bpf
              initrd initrd
              boot
            ''}
          ''}
        '';
    };
  };
}
