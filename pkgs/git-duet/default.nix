{ buildGoModule, fetchFromGitHub, stdenv, lib, writeText }:

buildGoModule rec {
  pname = "git-duet";
  version = "0.7.0";
  sha256 = "585f268b981aa0671f9314691a113fde63dc47cc";

  src = fetchFromGitHub {
    owner = "git-duet";
    repo = "git-duet";
    rev =  "${version}";
    sha256 = "1z6d6nda6qw337b751afgb4rycfjkvmfai1zvr83ik00dqw9bgy2";
  };

  vendorSha256 = null;

  doCheck = false;

  subPackages = [ "./git-duet" ];

  # preBuild = ''
  #   unset GOPROXY
  #   go mod tidy
  #   go mod vendor
  # '';

  buildFlagsArray = ''
    -ldflags=
    -X main.VersionString=${version} -X main.RevisionString=${sha256}
  '';

  meta = with lib; {
    description = "Support for pairing with git";
    homepage = "https://github.com/git-duet/git-duet";
    license = licenses.mit;
    maintainers = with maintainers; [ bodymindarts ];
  };
}
