{
  description = "Cartesian Reachability Logic -- A Report";

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.report = (
        let
            system = "x86_64-linux";
            pkgs = nixpkgs.legacyPackages.${system};
        in
          pkgs.stdenv.mkDerivation {
              name = "CRL-report";
              src = ./.;
              buildInputs = with pkgs; [
                  which
                  python310Packages.pygments
                  texlive.combined.scheme-full
                  ];
              phases = ["unpackPhase" "buildPhase" "installPhase"];
              buildPhase = ''
                mkdir -p $out
                latexmk -shell-escape -pdf main.tex
              '';

              installPhase = ''
                cp main.pdf $out/
              '';
          }
        );

    defaultPackage.x86_64-linux = self.packages.x86_64-linux.report;
  };
}
