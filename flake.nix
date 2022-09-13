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
                latexmk -shell-escape -pdf main.tex
              '';

              installPhase = ''
                mkdir -p $out
                cp main.pdf $out/
              '';
          }
        );

    defaultPackage.x86_64-linux = self.packages.x86_64-linux.report;
  };
}
