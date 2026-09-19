{
  flake.nixosModules.qurio = {
    pkgs,
    lib,
    ...
  }: let
    networkInterface = "enp0s13f0u1c2";
    internetInterface = "wlan0";
    hostIP = "10.250.50.1";
  in {
    systemd.network = {
      enable = true;
      wait-online.enable = false;

      netdevs = {
        "20-vlan-net" = {
          netdevConfig = {
            Kind = "vlan";
            Name = "vlan-net";
          };
          vlanConfig.Id = 10;
        };
        "20-vlan-game" = {
          netdevConfig = {
            Kind = "vlan";
            Name = "vlan-game";
          };
          vlanConfig.Id = 20;
        };
      };

      networks = {
        "20-usb-eth" = {
          matchConfig.Name = networkInterface;
          address = ["10.250.49.1/24"];
          vlan = ["vlan-net" "vlan-game"];
          linkConfig.RequiredForOnline = "no";
        };
        "30-vlan-net" = {
          matchConfig.Name = "vlan-net";
          address = ["10.250.51.1/24"];
          linkConfig.RequiredForOnline = "no";
        };
        "30-vlan-game" = {
          matchConfig.Name = "vlan-game";
          address = ["${hostIP}/24"];
          linkConfig.RequiredForOnline = "no";
        };
      };
    };

    networking.networkmanager.unmanaged = [
      "interface-name:${networkInterface}"
      "interface-name:vlan-net"
      "interface-name:vlan-game"
    ];

    networking = {
      firewall = {
        interfaces = {
          "${networkInterface}" = {
            allowedUDPPorts = [
              67
              68
              53
              123
            ];
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
      };

      nat = {
        internalInterfaces = ["vlan-net" networkInterface];
        externalInterface = internetInterface;
      };
      nftables = {
        tables = {
          nat = {
            family = "ip";
            content = ''
              chain postrouting {
                type nat hook postrouting priority 100; policy accept;
                iifname { ${networkInterface}, "vlan-net" } oifname "${internetInterface}" masquerade
              }
            '';
          };
        };
      };
    };

    services = {
      # Server DHCP and DNS for devices with internet access
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
            "set:net,10.250.51.50,10.250.51.70,12h"
            "set:mgmt,10.250.49.10,10.250.49.20,12h"
          ];

          dhcp-option = [
            "tag:game,option:dns-server,${hostIP}"
            "tag:game,3"
            "tag:game,6,${hostIP}"
            "tag:net,option:dns-server,8.8.8.8,1.1.1.1"
            "tag:mgmt,option:dns-server,8.8.8.8"
          ];

          address = [
            "/pool.ntp.org/10.250.49.1"
            "/arubanetworks.com/0.0.0.0"
            "/activate.arubanetworks.com/0.0.0.0"

            # Game
            "/qurio.game/${hostIP}"
          ];
        };
      };

      nginx = {
        enable = true;
        virtualHosts."proxy" = {
          default = true;
          listen = [
            {
              addr = "${hostIP}";
              port = 80;
            }
          ];
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:3000";
            };
          };
        };
      };
    };

    boot.kernel.sysctl."net.ipv4.ip_nonlocal_bind" = 1;

    systemd = {
      targets.qurio = {
        description = "Qurio game network services";
        wants = ["dnsmasq.service" "nginx.service"];
      };

      services = let
        tie = {
          wantedBy = lib.mkForce ["qurio.target"];
          partOf = ["qurio.target"];
        };
      in {
        dnsmasq = tie;
        nginx = tie;
      };
    };

    environment.systemPackages = with pkgs; [
      nodejs
    ];

    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-teleport
        obs-pipewire-audio-capture
      ];
    };
  };
}
