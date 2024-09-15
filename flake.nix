{
    description = "library flake.nix";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    };

    outputs = { self, nixpkgs} : 
        
        let 
            hello_lib_overlay = final: prev: rec {
                hello_lib = final.callPackage ./hellolib.nix { };
            };

            my_overlays = [ hello_lib_overlay ];

            pkgs = import nixpkgs {
                system = "x86_64-linux";
                overlays = [ self.overlays.default ];
            };

        in
        {
            packages.x86_64-linux.default = pkgs.hello_lib;
            overlays.default = nixpkgs.lib.composeManyExtensions my_overlays;
        };
    
}
