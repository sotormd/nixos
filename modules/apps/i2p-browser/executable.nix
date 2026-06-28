{
  firefox-unwrapped,
  wrapFirefox,
  policies,
  ...
}:

let
  firefox = wrapFirefox firefox-unwrapped { extraPolicies = policies; };
in
firefox
