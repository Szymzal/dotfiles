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
        internalInterfaces = ["vlan-net"];
        externalInterface = internetInterface;
      };
    };

    systemd.services.dnsmasq-game = let
      configFile = pkgs.writeText "dnsmasq-config.conf" ''
        interface=vlan-game
        except-interface=lo
        bind-interfaces
        dhcp-range=10.250.50.50,10.250.50.200,12h

        dhcp-option=option:dns-server,${hostIP}
        address=/#/${hostIP}
      '';
    in {
      description = "Captive Portal DHCP/DNS for Qurio";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.dnsmasq} -k -C ${configFile}";
      };
    };

    services = {
      # Server DHCP and DNS for devices with internet access
      dnsmasq = {
        enable = true;
        resolveLocalQueries = false;
        settings = {
          interface = "vlan-net";
          except-interface = "lo";
          bind-interfaces = true;
          dhcp-range = "10.250.51.50,10.250.51.70,12h";
          dhcp-option = "option:dns-server,8.8.8.8,1.1.1.1";
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
