# Secure Boot

This document covers setting up Secure Boot on the `laptop` role.

> WARNING: Secure Boot for NixOS is under active development. Make sure you read
> lanzaboote documentation before proceeding.

> WARNING: If dual booting with Windows, either disable bitlocker encryption or
> keep the recovery keys handy.

> NOTE: It is highly recommended to set a BIOS password on devices that support
> this feature. Without a BIOS password, Secure Boot can simply be disabled and
> is meaningless.

1. System requirements.

   Ensure you have booted in UEFI mode and Secure Boot is supported.

   ```bash
   bootctl status
   ```

   Consider setting up a BIOS password if you haven't already.

2. Create secure boot keys.

   ```bash
   nixos bootstrap lanzaboote create
   ```

3. Set `secureboot.enable` to `true` in the `features` section of the variables
   file.

   ```bash
   nixos edit vars
   ```

4. Switch to the new configuration.

   ```bash
   nixos switch
   ```

5. Verify `sbctl verify` output.

   ```bash
   sbctl verify
   ```

   It is expected that `bzImage.efi` files are not signed.

6. Enter Secure Boot setup mode in BIOS.

   Boot into EFI firmware and clear existing plaform keys (setup mode).

7. Boot into NixOS and enroll Secure Boot keys.

   ```bash
   nixos bootstrap lanzaboote enroll
   ```

8. Enable Secure Boot in BIOS.

   Boot into EFI firmware and enable Secure Boot.

9. Boot into NixOS and Secure Boot should be activated and in user mode.

   ```bash
   bootctl status
   ```
