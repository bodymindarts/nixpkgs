self: super:

{
  # ssoca = super.callPackage ../pkgs/ssoca { };
  # leftovers = super.callPackage ../pkgs/leftovers { };
  bosh = super.callPackage ../pkgs/bosh { };
  credhub = super.callPackage ../pkgs/credhub { };
  # boshBootloader = super.callPackage ../pkgs/bosh-bootloader { };
  # ytt = super.callPackage ../pkgs/ytt { };
  # vendir = super.callPackage ../pkgs/vendir { };
  kapp = super.callPackage ../pkgs/kapp { };    
  git_duet = super.callPackage ../pkgs/git-duet { };    
  # cf = super.callPackage ../pkgs/cf { };
  spruce = super.callPackage ../pkgs/spruce { };
  safe = super.callPackage ../pkgs/safe { };
  eden = super.callPackage ../pkgs/eden { };
  genesis = super.callPackage ../pkgs/genesis { };
}
