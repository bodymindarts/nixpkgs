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
  fly73 = fly "7.3.2" "0h6znpj5fmgjqpqcbvsv7kw6fi310lam7iw8pbg74a3k86mfygr0" "0g1rjs7ss0q5j9hbz5kykrkvl1sg6nxl82jay8mln7y88d3fnjnz";
  fly72 = fly "7.2.0" "1l3a9qhrdqk462fv2r7lcq5s725v5bv824wivc1sn9m03pkcvb5q" "1ljnn0swv9zv2kxa7g341iy5pbm3zjmq88c4k0zhsm4gag5dgyyq";
}
