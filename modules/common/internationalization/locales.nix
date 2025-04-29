{ vars, ... }:

{
  # locales
  i18n.defaultLocale = vars.i18n.locale;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = vars.i18n.locale;
    LC_IDENTIFICATION = vars.i18n.locale;
    LC_MEASUREMENT = vars.i18n.locale;
    LC_MONETARY = vars.i18n.locale;
    LC_NAME = vars.i18n.locale;
    LC_NUMERIC = vars.i18n.locale;
    LC_PAPER = vars.i18n.locale;
    LC_TELEPHONE = vars.i18n.locale;
    LC_TIME = vars.i18n.locale;
  };
}
