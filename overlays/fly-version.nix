self: super:

let
  fly = (versionArg: sha256Arg: vendorSha256Arg: (
    super.buildGoModule rec {
      pname = "fly";
      version = versionArg;

     src = super.fetchFromGitHub {
       owner = "concourse";
       repo = "concourse";
       rev = "v${version}";
       sha256 = sha256Arg;
     };

     vendorSha256 = vendorSha256Arg;

     doCheck = false;

     subPackages = [ "fly" ];

     buildFlagsArray = ''
       -ldflags=
         -X github.com/concourse/concourse.Version=${version}
     '';

     postInstall = super.lib.optionalString (super.stdenv.hostPlatform == super.stdenv.buildPlatform) ''
       mkdir -p $out/share/{bash-completion/completions,zsh/site-functions}
       $out/bin/fly completion --shell bash > $out/share/bash-completion/completions/fly
       $out/bin/fly completion --shell zsh > $out/share/zsh/site-functions/_fly
     '';

     meta = with super.lib; {
       description = "A command line interface to Concourse CI";
       homepage = "https://concourse-ci.org";
       license = licenses.asl20;
       maintainers = with maintainers; [ rkoster ];
     };
    }));
in {
  # fly60 = fly "6.0.0" "0chavwymyh5kv4fkvdjvf3p5jjx4yn9aavq66333xnsl5pn7q9dq" super.lib.fakeSha256;
  # nix-build '<nixpkgs>' -A fly60 # will get you the real sha
  fly77 = fly "7.7.0" "sha256-BKEUKQQxZ+Maq2JSHeWuQ7Lhgfc33pSiVS6VfAlMu/g=" "sha256-G9HdhPi4iezUR6SIVYnjL0fznOfiusY4T9ClLPr1w5c=";
  fly76 = fly "7.6.0" "sha256-Zi+gyO+2AKDgcfgYrzLskJYZ6hQKOVlOL7Y9nxH/pGg" "sha256-OF3parnlTPmcr7tVcc6495sUMRApSpBHHjSE/4EFIxE=";
  fly78 = fly "7.8.1" "sha256-A37XTLL6BcltKofriqai8RX+VQ4jcFRHriP4sUZ5g2c=" "sha256-aYu5K6pK6Q0Fmagr91i6nc3t55nUjn5vasIO+kUXWrs=";
  fly90 = fly "7.9.0" "sha256-YatN0VG3oEUK+vzJzthRnX+EkvUgKq2uIunAoPMoRag=" "sha256-nX0r/7V+rgJb3/9O91QskYzBpWXIca7m3Do1QtGuHgg=";
}
