{ buildGoModule, fetchFromGitHub, stdenv, lib, writeText }:

buildGoModule rec {
  pname = "kapp";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "carvel-kapp";
    rev = "v${version}";
    sha256 = "1i4hpqpbwqb0yg3rx4z733zfslq3svmahfr39ss1ydylsipl02mg";
  };

  vendorSha256 = null;

  doCheck = false;

  subPackages = [ "cmd/kapp" ];

  meta = with lib; {
    description = "kapp is a simple deployment tool focused on the concept of \"Kubernetes application\" — a set of resources with the same label";
    homepage = "https://carvel.dev/";
    license = licenses.asl20;
    maintainers = with maintainers; [ bodymindarts ];
  };
}
