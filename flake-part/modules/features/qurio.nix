{inputs, ...}: {
  flake.nixosModules.qurio = {
    pkgs,
    lib,
    ...
  }: let
    networkInterface = "enp2s0";
    internetInterface = "wlp0s20f3";
    hostIP = "10.250.50.1";
  in {
    networking = {
      vlans = {
        "vlan-net" = {
          id = 10;
          interface = "${networkInterface}";
        };
        "vlan-game" = {
          id = 20;
          interface = "${networkInterface}";
        };
      };

      interfaces = {
        "${networkInterface}".ipv4.addresses = [
          {
            address = "10.250.49.1";
            prefixLength = 24;
          }
        ];
        "vlan-net".ipv4.addresses = [
          {
            address = "10.250.51.1";
            prefixLength = 24;
          }
        ];
        "vlan-game".ipv4.addresses = [
          {
            address = "${hostIP}";
            prefixLength = 24;
          }
        ];
      };

      firewall.interfaces = {
        "${networkInterface}" = {
          allowedUDPPorts = [67 68 53];
        };
        "vlan-game" = {
          allowedTCPPorts = [
            80 # Captive Portal
            53 # DNS
            3000 # Qurio
          ];
          allowedUDPPorts = [
            67 # DHCP
            68 # DHCP
            53 # DNS
          ];
        };
        "vlan-net" = {
          allowedUDPPorts = [
            67 # DHCP
            68 # DHCP
            53 # DNS
          ];
        };
      };

      nat = {
        enable = true;
        internalInterfaces = ["vlan-net" networkInterface];
        externalInterface = internetInterface;
      };
    };

    # systemd.services.dnsmasq-game = let
    #   configFile = pkgs.writeText "dnsmasq-config.conf" ''
    #     interface=vlan-game
    #     except-interface=lo
    #     bind-dynamic
    #     dhcp-range=10.250.50.50,10.250.50.200,12h
    #
    #     dhcp-option=option:dns-server,${hostIP}
    #     address=/#/${hostIP}
    #   '';
    # in {
    #   description = "Captive Portal DHCP/DNS for Qurio";
    #   wantedBy = ["multi-user.target"];
    #   after = ["network.target"];
    #   serviceConfig = {
    #     ExecStart = "${lib.getExe pkgs.dnsmasq} -k -C ${configFile}";
    #   };
    # };

    services = {
      # Server DHCP and DNS for devices with internet access
      # dnsmasq = {
      #   enable = true;
      #   resolveLocalQueries = false;
      #   settings = {
      #     interface = ["vlan-net" networkInterface];
      #     except-interface = "lo";
      #     bind-dynamic = true;
      #
      #     dhcp-range = [
      #       "10.250.51.50,10.250.51.70,12h"
      #       "10.250.49.10,10.250.49.20,12h"
      #     ];
      #     dhcp-option = "option:dns-server,8.8.8.8,1.1.1.1";
      #   };
      # };
      dnsmasq = {
        enable = true;
        resolveLocalQueries = false;

        settings = {
          interface = ["vlan-net" "vlan-game" networkInterface];
          except-interface = "lo";
          bind-dynamic = true;

          dhcp-host = "F0:5C:19:C1:EC:52,10.250.49.10";

          dhcp-range = [
            "set:game,10.250.50.50,10.250.50.200,12h"
            "set:net,10.250.51.50,10.250.50.70,12h"
            "set:mgmt,10.250.49.10,10.250.49.20,12h"
          ];

          dhcp-option = [
            "tag:game,option:dns-server,${hostIP}"
            "tag:net,option:dns-server,8.8.8.8,1.1.1.1"
            "tag:mgmt,option:dns-server,1.1.1.3"
          ];

          address = "/#/${hostIP}";
        };
      };

      nginx = {
        enable = true;
        virtualHosts."captiveportal" = {
          default = true;
          listen = [
            {
              addr = "${hostIP}";
              port = 80;
            }
          ];
          locations = {
            "/" = {
              return = "302 http://${hostIP}:3000";
            };
          };
        };
      };
    };

    environment.systemPackages = with pkgs; [
      nodejs_20
    ];

    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-teleport
      ];
    };
  };
}
