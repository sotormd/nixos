{ config, ... }:

{
  # locales
  i18n.defaultLocale = config.vars.localization.locale;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = config.vars.localization.locale;
    LC_IDENTIFICATION = config.vars.localization.locale;
    LC_MEASUREMENT = config.vars.localization.locale;
    LC_MONETARY = config.vars.localization.locale;
    LC_NAME = config.vars.localization.locale;
    LC_NUMERIC = config.vars.localization.locale;
    LC_PAPER = config.vars.localization.locale;
    LC_TELEPHONE = config.vars.localization.locale;
    LC_TIME = config.vars.localization.locale;
  };
}
