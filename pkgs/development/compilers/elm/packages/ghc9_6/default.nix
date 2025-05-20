{
  pkgs,
  lib,
  makeWrapper,
  nodejs,
  fetchElmDeps,
}:

self:
pkgs.haskell.packages.ghc96.override {
  overrides =
    self: super:
    let
      inherit (pkgs.haskell.lib.compose) overrideCabal;
      elmPkgs = rec {
        elm = overrideCabal (drv: {
          # sadly with parallelism most of the time breaks compilation
          enableParallelBuilding = false;
          preConfigure = fetchElmDeps {
            elmPackages = (import ../elm-srcs.nix);
            elmVersion = drv.version;
            registryDat = ../../registry.dat;
          };
          buildTools = drv.buildTools or [ ] ++ [ makeWrapper ];
          postInstall = ''
            wrapProgram $out/bin/elm \
              --prefix PATH ':' ${lib.makeBinPath [ nodejs ]}
          '';

          patches = [
            # Fix TLS compatibility issues with package.elm-lang.org
            # see: https://github.com/elm/compiler/pull/2325
            ./tls-compatibility.patch
          ];

          description = "Delightful language for reliable webapps";
          homepage = "https://elm-lang.org/";
          license = lib.licenses.bsd3;
          maintainers = with lib.maintainers; [
            turbomack
          ];
        }) (self.callPackage ./elm { });

        lamdera = overrideCabal (drv: {
          # sadly with parallelism most of the time breaks compilation
          enableParallelBuilding = false;
          preConfigure = fetchElmDeps {
            elmPackages = (import ../elm-srcs.nix);
            elmVersion = drv.version;
            registryDat = ../../registry.dat;
          };
          buildTools = drv.buildTools or [ ] ++ [ makeWrapper ];
          postInstall = ''
            wrapProgram $out/bin/elm \
              --prefix PATH ':' ${lib.makeBinPath [ nodejs ]}
          '';

          description = "Delightful platform for full-stack Elm web apps.";
          homepage = "https://lamdera.com/";
          license = lib.licenses.bsd3;
          maintainers = with lib.maintainers; [
            domenkozar
            turbomack
          ];
        }) (self.callPackage ./lamdera { });

        inherit fetchElmDeps;
        elmVersion = elmPkgs.elm.version;
      };
    in
    elmPkgs
    // {
      inherit elmPkgs;

      ansi-wl-pprint = overrideCabal (drv: {
        jailbreak = true;
      }) (self.callPackage ./ansi-wl-pprint { });

      avh4-lib = self.callPackage ../ghc9_2/elm-format/avh4-lib.nix { };

      elm-format-lib = self.callPackage ../ghc9_2/elm-format/elm-format-lib.nix { };

      elm-format-markdown = overrideCabal (drv: {
        jailbreak = true;
      }) (self.callPackage ../ghc9_2/elm-format/elm-format-markdown.nix { });

      elm-format-test-lib = self.callPackage ../ghc9_2/elm-format/elm-format-test-lib.nix { };

      elm-format = self.callPackage ../ghc9_2/elm-format/elm-format.nix { };
    };
}
