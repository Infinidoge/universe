# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  qtile = {
    pname = "qtile";
    version = "4c69fca361bcb1d9753b37b9b903af32b27983c5";
    src = fetchFromGitHub ({
      owner = "qtile";
      repo = "qtile";
      rev = "4c69fca361bcb1d9753b37b9b903af32b27983c5";
      fetchSubmodules = false;
      sha256 = "sha256-c/1+17k+kx5M9c/VcXA6+o9GWzbM69IJkhCbK8NEdlc=";
    });
    date = "2023-02-27";
  };
}
