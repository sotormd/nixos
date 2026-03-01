{ config, ... }:

{
  # locales
  i18n.defaultLocale = config.vars.i18n.locale;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = config.vars.i18n.locale;
    LC_IDENTIFICATION = config.vars.i18n.locale;
    LC_MEASUREMENT = config.vars.i18n.locale;
    LC_MONETARY = config.vars.i18n.locale;
    LC_NAME = config.vars.i18n.locale;
    LC_NUMERIC = config.vars.i18n.locale;
    LC_PAPER = config.vars.i18n.locale;
    LC_TELEPHONE = config.vars.i18n.locale;
    LC_TIME = config.vars.i18n.locale;
  };
}
