{ suites, profiles, pkgs, lib, private, ... }: {
  imports = lib.lists.flatten [
    (with suites; [
      base
      develop
    ])

    private.nixosModules.wireless

    ./hardware-configuration.nix
  ];

  system.stateVersion = "21.11";

  environment.persistence."/persist" = {
    directories = [
      "/home"
      "/etc/nixos"
      "/etc/nixos-private"

      # /var directories
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/systemd/coredump"
      "/var/lib/tailscale"
      "/var/lib/alsa"

      "/srv"
    ];

    files = [
      "/etc/machine-id"

      "/root/.local/share/nix/trusted-settings.json"
      "/root/.ssh/known_hosts"
      "/root/.ssh/id_ed25519"
      "/root/.ssh/id_ed25519.pub"
      "/root/.ssh/immutable_files.txt"
    ];
  };

  modules = {
    boot.grub.enable = true;
    hardware = {
      gpu.nvidia = true;
      wireless.enable = true;
      form.desktop = true;

      # FIXME: openrazer does not properly build under Linux 5.18
      # peripherals.razer.enable = true;
    };
    services = {
      foldingathome = {
        enable = false;
        user = "Infinidoge";
        extra = {
          control = true;
          viewer = true;
        };
      };
      apcupsd = {
        enable = true;
        primary = true;
        config = {
          address = "0.0.0.0";
        };
      };
    };
    desktop = {
      wm.enable = true;
      gaming.enableAll = true;
    };
    virtualization.enable = true;
  };

  home = { profiles, pkgs, ... }: {
    imports = with profiles; [ stretchly ];
    home.packages = with pkgs; [
      hydrus
      sidequest
    ];
  };

  services.minecraft-servers = {
    enable = true;

    servers = {
      emd-server = {
        enable = true;
        autoStart = false;

        package = pkgs.minecraftServers.quilt-1_19_2;
        jvmOpts = "-Xmx6144M -Xms1024M";

        serverProperties = {
          server-port = 25672;
          allow-flight = true;
          spawn-protection = 0;
          white-list = true;
          enable-command-block = true;
          difficulty = "normal";
        };

        symlinks = {
          mods = pkgs.linkFarmFromDrvs "mods" (map pkgs.fetchurl (builtins.attrValues {
            # API
            FabricPermissionsAPI = { url = "https://github.com/lucko/fabric-permissions-api/releases/download/v0.2/fabric-permissions-api-v0.2.jar"; sha256 = "1wl5faxyks864igmr1kdfndwwwxfn951ycb7m6ivpwdpw6ddfd35"; };
            MidnightLib = { url = "https://cdn.modrinth.com/data/codAaoxh/versions/WjT0Llfm/midnightlib-0.6.1.jar"; sha512 = "09c2bee7b133b320374fe3c4b004b417d45940ca64a0370916e8b5ea5c0f2a7d6a3365b1bf6bcb4b44e6a190be545b871e24579e7c102f95b6652597eb0e1a06"; };
            NBTCrafting = { url = "https://cdn.modrinth.com/data/18ztUZP5/versions/qmlecz7K/nbtcrafting-2.2.0%2Bmc1.19.jar"; sha512 = "8654a9aed0f7512c6a10b91d33b6519acfa6fec989c1b788d081203b154d0a603acc7c243695b4f2f1c824c1e34c2a2a3b6e065b5f744be19065e3f4190b82f3"; };
            PlayerAbilityLib = { url = "https://mediafiles.forgecdn.net/files/3800/599/pal-1.6.0.jar"; sha256 = "12msaizf3w984q8k41j6i4yia9lz9060kjghyh75dr7s9nmx6vf5"; };
            QKL = { url = "https://cdn.modrinth.com/data/lwVhp9o5/versions/RFKK2wt2/quilt-kotlin-libraries-0.1.2-MODFEST%2Bkt.1.7.10%2Bflk.1.8.2.jar"; sha512 = "3a101ef5e9cabcb8a676f727e3ece7f77e55b76d9b4c608567b012fec3591686492436e95b2a554fa1f6afca11a1c468dccdcbb4aaf2413ad0860b390bbf9df2"; };
            QSL = { url = "https://cdn.modrinth.com/data/qvIfYCYJ/versions/VNZ3SkYT/quilted-fabric-api-4.0.0-beta.12%2B0.61.0-1.19.2.jar"; sha512 = "f826c88958985825d1b4381df1b4279853432b8a488885bdd65db8d955b73523a08f16738692a8cf4a31002fbf6747445c6c1242673f35a54b881667e3268050"; };
            Statement = { url = "https://cdn.modrinth.com/data/a9AsUNGn/versions/4.2.4+1.14.4-1.19.1/Statement-4.2.4%2B1.14.4-1.19.1.jar"; sha512 = "3b1bedafc1bbe59f4c98e21e90b80a7a0852dd8f811586bc71084c4cd3ebdf51d55b9f708a7f59020517161e7cbcb2b73b641105211b6770e73d769d315dd23f"; };

            # Optimisation
            AlternateCurrent = { url = "https://cdn.modrinth.com/data/r0v8vy1s/versions/mc1.19-1.4.0/alternate-current-mc1.19-1.4.0.jar"; sha512 = "23dd5b3912250ec813d20e508685bde5b3e0ec923992b2329e39be9c272b7d2dec50c5e942d4cbb3ef044a554fa101903f35749fea8635d2ce7af0ebe54ee38c"; };
            # C2ME = { url = "https://cdn.modrinth.com/data/VSNURh3q/versions/YaQCrYHB/c2me-fabric-mc1.19.2-0.2.0%2Balpha.9.0.jar"; sha512 = "53a359554ae3fa2e4b64eab3b34bac4d6624b23694fbaf5c324cc691767f8616827412805ad7a283d835ad9103f24b79f93a433f05d200ca9bc6916ed2fa2486"; };
            FerriteCore = { url = "https://cdn.modrinth.com/data/uXXizFIs/versions/5.0.0-fabric/ferritecore-5.0.0-fabric.jar"; sha512 = "ea54167b9c054a7e486dc01113ee9fc6d3ed0e527cb2fe238f7f5ba5823ac18f4e7c70bf89d14c9845485ca881b757b7672cda610c7fac580fd55db7070d02b4"; };
            Krypton = { url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/0.2.1/krypton-0.2.1.jar"; sha512 = "4dec2caf697fd5152f38b8ec774e32f83c2148c9f9ac06afb129fa434f24384751628e7ab700f783aec54a1cf50e650f32c6391fc8d4585f5789bc55e5e91d91"; };
            Lithium = { url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/xVm1caOt/lithium-fabric-mc1.19.2-0.10.1.jar"; sha512 = "9c59e9d9b149e3d45f283e4f8f8e37d717aa4c8d7418e6e9f288d50ca23fbde469b62b5e4fdf65a6abfb8786df8532db2724ca8f7f11baa6360bd00241ff20ea"; };
            MemoryLeakFix = { url = "https://cdn.modrinth.com/data/NRjRiSSD/versions/v0.7.0/memoryleakfix-1.19.1-0.7.0.jar"; sha512 = "885447011054bf6ae936da5f1e795f135c29d509535c00b2351b8ffc70405e8afd2ed513d1d3c846d8ac54d713800e417579ccf437bcdd2b3c29fb9445ef3d67"; };
            SmoothBoot = { url = "https://cdn.modrinth.com/data/FWumhS4T/versions/1.19-1.7.1/smoothboot-fabric-1.19-1.7.1.jar"; sha512 = "dfe62d6ae465baa6b60249f271508bb97e5f07f663c018658dfb940f99e7fce5fa9f5b6c15e555db34b02f8db9d8e6350cb120e10469ff809480173fb8b0da49"; };
            Starlight = { url = "https://cdn.modrinth.com/data/H8CaAYZC/versions/1.1.1+1.19/starlight-1.1.1%2Bfabric.ae22326.jar"; sha512 = "68f81298c35eaaef9ad5999033b8caf886f3c583ae1edc25793bdd8c2cbf5dce6549aa8d969c55796bd8b0d411ea8df2cd0aaeb9f43adf0691776f97cebe1f9f"; };

            # Server Utility
            ChunkyPregenerator = { url = "https://cdn.modrinth.com/data/fALzjamp/versions/wFqA1p32/Chunky-1.3.38.jar"; sha512 = "8bf38f9b7212e9637ab7899cc4ad66ab55c60d9006daf4b576d3ab3881e8be82e7cecb1df85bba061a03c7ecf7210fa463034d2a586272cb2a74674af3bfb1bb"; };
            Drogtor = { url = "https://cdn.modrinth.com/data/yepDrPAy/versions/1.1.3+1.19/drogtor-1.1.3.jar"; sha512 = "81ec431c7678ee45b651a533bf264e7fb4407e901949dec675d6f63ebf91b8cb715f7f44e300788eca2b3e5aee6b0119c3672ecab4c224276ab96a678cbe0aa6"; };
            JLine4MCDedicatedServer = { url = "https://mediafiles.forgecdn.net/files/3958/604/jline4mcdsrv-0.3.1.jar"; sha256 = "0ngnh5sp2da5ikhw2jpgnnhfg2r4q4bn0h4312m6ikdlp22ivxsr"; };
            MultiWorldBorders = { url = "https://cdn.modrinth.com/data/M7MroYMU/versions/1.5/multiworldborders-1.5-fabric-1.19.jar"; sha512 = "2480cd06aa3a3079fcf8a0dd3424c42d57a8f4216d275dcb1b8284e4ebc3d6c2ca6b984ac9c2ac54256631615d0cc05480696f1c3ac272789b55e39ae66bb7cc"; };
            NoChatReports = { url = "https://cdn.modrinth.com/data/qQyHxfxd/versions/CrvlUGPx/NoChatReports-FABRIC-1.19.2-v1.12.0.jar"; sha512 = "c0f1baa6e2bdecfc16b4c8253bdc154d66f6402059cc6174c6b371a08a236f37b9890b0d5eb74fd3df379d7a4eb07573f5ca58e528016c534e41ab22ebde3883"; };
            NotEnoughCrashes = { url = "https://cdn.modrinth.com/data/yM94ont6/versions/HZlh6stm/notenoughcrashes-4.1.8%2B1.19.2-fabric.jar"; sha512 = "3f80561ce58e128ba3cd213ef7713d42eabc8aa8d114afa4ebd308fccb5e7ed2cf0e6376ccb66b998aca7865b37a5ab5e4b3da0e07973c160ee8d124487497aa"; };
            PlayerPronouns = { url = "https://cdn.modrinth.com/data/gE0ebYRh/versions/1.5.0+1.19/player-pronouns-1.5.0%2B1.19.jar"; sha512 = "fa6c07e13c9c77ce2740c78e99596355e263f2a9892c47d71e96297d5c21ece9df5625af118463f05f6d5d36d86bf3bddff3036204d0c2cfe827b70440c8172a"; };
            ServerTick = { url = "https://cdn.modrinth.com/data/nEKRNLz9/versions/1.7/servertick-mc1.19-1.7.jar"; sha512 = "b1908b723f5ae1c1f4a666073dacd3a55a376e3422beda73c7772f87d84520c98f7a94bab69bd9a3e6713641a499bfd34acb62ebf81f6fd803c544091f068efe"; };
            # SimpleEndDisable = { url = "https://cdn.modrinth.com/data/wDLJnjgm/versions/iJT4FVFE/simple_end_disable-1.0.0%2B1.19.2.jar"; sha512 = "16fd9285f5a22a5f8be52d5fc00abcc2b544eb94abed1b2f54248189944f72e59c4622bdd4081a88f2f6830f2c4eb8db56df97fabd5b541957a2839434972495"; };
            StyledPlayerList = { url = "https://cdn.modrinth.com/data/DQIfKUHf/versions/2.2.2+1.19.1/styledplayerlist-2.2.2%2B1.19.1.jar"; sha512 = "315d5729bbecf57292221e06926d19bde544c9642e6ab0503461b15d252cd616e08d234575ef6a3d0a63566b22d5b896d12c5fd09f274f335b9fda01a9b736f0"; };
            carpet = { url = "https://github.com/gnembon/fabric-carpet/releases/download/1.4.83/fabric-carpet-1.19.1-1.4.83+v220727.jar"; sha256 = "1cm9572cz0d1ij24zhm4kyjwpmx49yh2asfr8cg7959c4kh3dcd1"; };
            spark = { url = "https://cdn.modrinth.com/data/l6YH9Als/versions/FnKxsd40/spark-1.9.40-fabric.jar"; sha512 = "bab7609e5aae360421f21652fa084f0c01b9b900609a1163597a911199cdd19056b1389736e371f1fb96efb8b39cb9d1eb9b010a459e33307b47181d0babd6e6"; };

            # Moderation
            Flan = { url = "https://mediafiles.forgecdn.net/files/3915/913/flan-1.19-1.8.1-fabric.jar"; sha256 = "11zlv79xpgpw0n9izf7gf4ifwbbwpamy1yjn0qqp5xalp234bdi3"; };
            InvView = { url = "https://cdn.modrinth.com/data/jrDKjZP7/versions/1.4.9/InvView-1.4.9-1.19%2B.jar"; sha512 = "033ef17412960f917baa546807bacb622c9ad29c9cc9040969b6b0ef5b91430c4a925a2157776c680687ba07815c13422e1e6b6730f8cfce9ab205c1f571a1d3"; };
            PlayerRoles = { url = "https://cdn.modrinth.com/data/Rt1mrUHm/versions/1.6.1/player-roles-1.6.1.jar"; sha512 = "2aba546a8ed01fa9c5e11dde237037f84981b8ed1d248bc81538b13fee081795151de10e34329d54100690bff8e46e3333992820e001a94dbaa0e27b23e07d1c"; };
            TogglePVP = { url = "https://mediafiles.forgecdn.net/files/3892/427/toggle-pvp-1.0.4.jar"; sha256 = "0x7n0dwm39j636cbpdimaa1dpggyhzbhv2gwf6jdd9xyfw3sgq44"; };

            # Client Side Support
            AppleSkin = { url = "https://cdn.modrinth.com/data/EsAfCjCV/versions/fabric-mc1.19-2.4.1/appleskin-fabric-mc1.19-2.4.1.jar"; sha512 = "13595728a6c81bec1537951b479b16852d74f1cf348b92a4caaf9742d51d4dd511805ef2d04cfea95ed16f1389a1156d6244c2fdcd7209043f2ecd1ac6539c2e"; };
            EMI = { url = "https://cdn.modrinth.com/data/fRiHVvU7/versions/IoW80f9m/emi-0.4.0%2B1.19.jar"; sha512 = "44ed5551a9749fb2e4beefc26411f2a16d1ce4bebc58f1f0caca4a489b0903eedf7c881aa009b4003f6c0f6568fc019c12e4dded9dd077ccd400b28976a89513"; };
            Inspecio = { url = "https://cdn.modrinth.com/data/a93H3mKU/versions/1.6.0+1.19/inspecio-1.6.0%2B1.19.jar"; sha512 = "46d7c73577ec2bbd292fdeaaa2e91e54142db9a1fb700299fcfc5711494d5cbaecce1720c23e61f7586f8f994a69bb089128f39b73f5ce8eb84c33dce5030b81"; };
            InventorySorting = { url = "https://mediafiles.forgecdn.net/files/3885/990/InventorySorter-1.8.10-1.19.jar"; sha256 = "0rygxrsqyjnxa9ggkkafj024qjw525igirnpi5dyml8sp2a9nxmq"; };

            # Miscellaneous
            Crowmap = { url = "https://cdn.modrinth.com/data/EAe3MQt5/versions/1.0.1-fabric-1.19/crowmap-1.19-1.0.1.jar"; sha512 = "c785124b95e0a97d2654b00387e639f7b4c99773e9c1c10cf48838ee63ffe06ab2b06886407ad67fcfdba2fc8e7a94c7d8063e87a3d40f0740c3f0d9e9845215"; };
            Fabrication = { url = "https://cdn.modrinth.com/data/B3Eg0WhA/versions/2Qbacsc4/fabrication-3.0.3%2B1.19.jar"; sha512 = "008a1d8f3a27c7ee44c57d536292e1aae2b42cbccfa4b3ed3cf5026560e3422f85d126369a5abf4c41bcbf3e446df780d8f848aeb8689da2de5bcbdc2c984f39"; };
            FreedomOfInsomnia = { url = "https://cdn.modrinth.com/data/whQNiSQb/versions/v1.2.0/freedomofinsomnia-1.2.0.jar"; sha512 = "a946d1c84bb2b83719195399bff0cc0b9cd93335ff02fc99d81caff17f30e555c02f7f5b1058a47e883bd875ca1f87279055df668ec6bbbad6318ca9fd5e8b7c"; };
            GrindEnchantments = { url = "https://cdn.modrinth.com/data/WC4UgDcZ/versions/YjECeC3L/grind-enchantments-2.0.0-beta.2%2B1.19.2.jar"; sha512 = "9f52114bc1368edcb1ef0263c718f8a4398cdec65ea38d6c03fcf303c14ce722d5d443e3bd708ebc90fbbe7c8b25f1bfaedd5a0b3f9345a1f8c12c931ea4ec23"; };
            HorseStonks = { url = "https://cdn.modrinth.com/data/Vj70oKlA/versions/1.0.1/horse-stonks-1.0.1.jar"; sha512 = "8a5bff1be5364f6f56882e48e61c49f1bd0c7383a2917243759f5135448f84e38e0b9d01350bbb6b3cc067b2c9eea334d1c8cab07b6f4909cfa932fbac120219"; };
            ScaffoldingExtension = { url = "https://cdn.modrinth.com/data/LCRW61rP/versions/1.1.4+MC1.19-1.19.2/scaffolding-extension-1.1.4%2BMC1.19-1.19.2.jar"; sha512 = "41a6a2c9fd636254d6b73d19ecab26f2a067ae2a2e1900e2cd7697e5a395a9a1c4e2925938e54897ec9f9336bfb9e74956c6020dd7ab30d97824ddda22cd9c03"; };
            TaxFreeLevels = { url = "https://cdn.modrinth.com/data/jCBrrLTs/versions/1.3/TaxFreeLevels-1.3.jar"; sha512 = "3d77e3590e53b07c3ce9261ac0dd1988913580950a4388631746689b19cb7417f236c31dc01907296300f66b7833a2cf5868f29c790b8dea75866b75a818fc5c"; };
            TinkerersSmithing = { url = "https://cdn.modrinth.com/data/RhVpNN5O/versions/1.0.0/tinkerers-smithing-1.0.0.jar"; sha512 = "739fa4ed28263f63a2f5c6602325323777fac2e59bb504a1cc041488a390754d1d897a3acbff4a159f5c3d3a2e2cec3dd80a73c8c05bf58b9e0b8a3aaf658dae"; };

            # World Generation
            AmplifiedNether = { url = "https://cdn.modrinth.com/data/wXiGiyGX/versions/FBqJR2QM/Amplified_Nether_v1.2.jar"; sha512 = "f1ae06586d76879bc20c985b256d59c9c9abec0ff97260b9956d344040abff5b56d487aa674db38eda19868d99297c1bc834d07bea689ebedf7cdc87570e3984"; };
            Nullscape = { url = "https://mediafiles.forgecdn.net/files/3862/219/Nullscape_v1.2a.jar"; sha256 = "08p7nych6qby4zkknb6va8jdschh779yd2a0ir0ln6gbz1whahgm"; };
            RepurposedStructures = { url = "https://cdn.modrinth.com/data/muf0XoRe/versions/tYzItxkG/repurposed_structures_quilt-6.2.3%2B1.19.2.jar"; sha512 = "243d27e928176228ec2d1fa466b42bd31fe6e16879a6e83371fba1ef2d7e69eb960216b55dc5f7e8ea013e29ee9101ab1e8147a1056dd5acb734de3135dbc816"; };
            Structory = { url = "https://mediafiles.forgecdn.net/files/3878/691/Structory-1.19-1.2.jar"; sha256 = "1mrqqkfrb6n1n9qda0ns93vg2pqxfcg73z6bdb1yaqx5viik54sq"; };

            # Disabled
            # TabTPS = { url = "https://cdn.modrinth.com/data/cUhi3iB2/versions/WWxVTUNm/tabtps-fabric-mc1.19.2-1.3.15.jar"; sha512 = "24add0d714189dd30d1dbe801d52537e399849cec1cfd5d41801eafebdcb93390ba2be54435239dcc16d32c3585b9349f9508af2ea59cf088ec4e3c5b2392efc"; };
            # StyledChat = { url = "https://cdn.modrinth.com/data/doqSKB0e/versions/1.4.1+1.19.2/styled-chat-1.4.1%2B1.19.2.jar"; sha512 = "0fdbc0774cea996fb46f4a56c5963d87625375e332242fae57fdb5998498c5c3e9938584b4aacaefba36fd12960c8dd652a6a8c1b44a97685e9202ff4a9e3c6b"; };
            # VanillaDisable = { url = "https://cdn.modrinth.com/data/udzOW1ID/versions/v2.1.0-1.19.1/vanilla_disable-mc1.19.1-2.1.0-quilt.jar"; sha512 = "8e7d16c374bf289feee32db64e9b1b231111223b9743246a01d3e5dab5f6d6b85eaa70d125da0af6f35916e22f37394bad002322e13e0ba83ac9b37ee039e78e"; };
          }));
        };
      };
    };
  };
}
