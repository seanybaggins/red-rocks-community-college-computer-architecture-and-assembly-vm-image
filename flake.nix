{
  description = "Red Rocks Community College Computer Architecture and Assembly vm build description";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

  outputs =
    {
      ...
    }@inputs:
    let
      pkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
        overlays = [

        ];
        config = {
          #allowUnfree = true;
        };
      };
    in
    {
      nixosConfigurations.rrcc-comp-arch-and-assembly-vm = inputs.nixpkgs.lib.nixosSystem {
        inherit pkgs;
        system = "x86_64-linux";
        modules = [
          "${inputs.nixpkgs}/nixos/modules/virtualisation/virtualbox-image.nix"
          ./nixos/configuration.nix
        ];

        specialArgs = { inherit inputs; };

      };

      packages.x86_64-linux = {
        default = inputs.self.packages.x86_64-linux.vmImage;

        vmImage =
          inputs.self.nixosConfigurations.rrcc-comp-arch-and-assembly-vm.config.system.build.virtualBoxOVA;

      };

      checks.x86_64-linux = inputs.self.packages.x86_64-linux;

      inherit pkgs;
    };
}
