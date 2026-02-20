# Secure Boot

This document covers setting up Secure Boot on the `laptop` role.

> WARNING: Secure Boot for NixOS is under active development. Make sure you read
> lanzaboote documentation before proceeding.

> WARNING: If dual booting with Windows, either disable bitlocker encryption or
> keep the recovery keys handy.

1. System requirements.

   Ensure you have booted in UEFI mode and Secure Boot is supported.

   ```bash
   bootctl status
   ```

   Consider setting up a BIOS password if you haven't already.

2. Create secure boot keys.

   ```bash
   nixos init lanzaboote create
   ```

   Set `device.secureboot.enable = true;` in the variables file.

   ```bash
   nixos edit vars
   ```

   Switch to the new configuration.

   ```bash
   nixos switch
   ```

   Verify `sbctl verify` output.

   ```bash
   sbctl verify
   ```

   It is expected that `bzImage.efi` files are not signed.

3. Enter Secure Boot setup mode in BIOS.

   Boot into EFI firmware and clear existing plaform keys (setup mode).

4. Boot into NixOS and enroll Secure Boot keys.

   ```bash
   nixos init lanzaboote enroll
   ```

5. Enable Secure Boot in BIOS.

   Boot into EFI firmware and enable Secure Boot.

   Boot into NixOS and Secure Boot should be activated and in user mode.

   ```bash
   bootctl status
   ```
