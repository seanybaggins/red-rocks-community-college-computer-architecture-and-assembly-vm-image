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
          pkgs.runCommand "split-ova"
            {
              nativeBuildInputs = [ pkgs.coreutils ];
            }
            ''
              mkdir -p $out
              # Copy the OVA
              cp ${inputs.self.nixosConfigurations.rrcc-comp-arch-and-assembly-vm.config.system.build.virtualBoxOVA}/*.ova $out/vm.ova
              cd $out

              # Split into 1.9GB chunks to stay under GitHub's 2GB limit
              split -b 1900M -d vm.ova vm-part-
              rm vm.ova

              # Create a reassembly script for users
              cat > reassemble.sh << 'EOF'
              #!/usr/bin/env bash
              cat vm-part-* > rrcc-vm.ova
              echo "VM image reassembled: rrcc-vm.ova"
              EOF
              chmod +x reassemble.sh
            '';

      };

      checks.x86_64-linux = inputs.self.packages.x86_64-linux;

      inherit pkgs;
    };
}
