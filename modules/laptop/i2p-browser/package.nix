{ pkgs, ... }:

let
  policies = import ./policies.nix;
in
{
  policiesFirefox = pkgs.wrapFirefox pkgs.firefox-unwrapped {
    extraPolicies = policies.extraPolicies;
  };
}
