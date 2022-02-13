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
  fly76 = fly "7.6.0" "sha256-Zi+gyO+2AKDgcfgYrzLskJYZ6hQKOVlOL7Y9nxH/pGg" "sha256-OF3parnlTPmcr7tVcc6495sUMRApSpBHHjSE/4EFIxE=";
  fly75 = fly "7.5.0" "1085gxjrc5fh6a1j2cjcv3h4na4cabcliw6isgf0aimqz4ic1v77" "0dhcs5ma968bii2np51zbib2kvc8g8cpjkwzvnzgpmz7pi4z3b37";
  fly74 = fly "7.4.0" "0hy5sndqnbci42wc336hand9xkqkf6q5xdchxmjknnshkd6hzwaj" "02dknyv3nxy55dspdcv321x4db8hfxqmz0jivkijyd8a18d8g3r1";
}
