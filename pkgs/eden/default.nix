{ buildGoModule, fetchFromGitHub, stdenv, lib, writeText }:

buildGoModule rec {
  pname = "eden";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "starkandwayne";
    repo = "eden";
    rev =  "v${version}";
    sha256 = "1wmd3mrqfk6b88jmmfldwbq4ajjvg6md8vqjcs0xbz1cm0m3scvf";
  };

  vendorSha256 = null;

  doCheck = false;

  subPackages = [ "." ];

  buildFlagsArray = ''
    -ldflags=
    -X main.Version=${version}
  '';

  meta = with lib; {
    description = "Interact with any Open Service Broker API to discover/provision/bind/unbind/deprovision hundreds of different services.";
    homepage = "https://github.com/starkandwayne/eden";
    license = licenses.mit;
    maintainers = with maintainers; [ rkoster ];
  };
}
