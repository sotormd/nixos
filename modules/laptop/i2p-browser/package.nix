{ pkgs, vars, ... }:

let
  policies = import ./policies.nix { inherit vars; };
in
{
  policiesFirefox = pkgs.wrapFirefox pkgs.firefox-unwrapped {
    extraPolicies = policies.extraPolicies;
  };
}
