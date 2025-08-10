# NixOS TPM Recovery and Maintenance Guide

_Created by Claude AI._

This guide covers how to restore TPM automatic unlocking when it stops working due to firmware updates, hardware changes, or other issues.

## When TPM Unlocking Stops Working

### Common Causes

- **Firmware/BIOS updates** - Changes PCR measurements
- **Kernel updates** (if using restrictive PCRs)
- **Hardware changes** - New RAM, storage devices
- **TPM cleared/reset** - Manual or automatic TPM reset
- **Secure Boot changes** - Enabling/disabling affects PCR 7

### Symptoms

- System asks for LUKS password on every boot
- Previously worked automatically
- Password still works (fallback is intact)

## Diagnostic Steps

### Step 1: Check Current Status

```bash
# Check if TPM is still functional
sudo tpm2_selftest
sudo tpm2_getrandom 8 --hex

# Check current LUKS enrollments
sudo systemd-cryptenroll --list /dev/disk/by-uuid/YOUR-LUKS-UUID

# Check what's currently enrolled
sudo cryptsetup luksDump /dev/disk/by-uuid/YOUR-LUKS-UUID | grep "Key Slot"
```

### Step 2: Check TPM Device Access

```bash
# Verify TPM devices exist
ls -la /dev/tpm*

# Should show both:
# /dev/tpm0     - Direct TPM access
# /dev/tpmrm0   - TPM Resource Manager (preferred)

# Test TPM communication
sudo TPM2TOOLS_TCTI="device:/dev/tpmrm0" tpm2_selftest
```

### Step 3: Check PCR Values

```bash
# View current PCR values
sudo tpm2_pcrread

# Compare with what might have changed:
# PCR 0: UEFI firmware
# PCR 2: Option ROM code  
# PCR 4: Boot loader (if used in enrollment)
# PCR 7: Secure Boot state
```

## Recovery Procedures

### Procedure A: Simple Re-enrollment (Most Common)

This works for most firmware updates and minor system changes:

```bash
# Remove existing TPM enrollment
sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/disk/by-uuid/YOUR-LUKS-UUID

# Re-enroll with same PCR combination
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+2+7 /dev/disk/by-uuid/YOUR-LUKS-UUID

# Test immediately
sudo reboot
```

### Procedure B: Clear TPM and Re-enroll

If simple re-enrollment fails:

```bash
# Clear TPM completely (removes all TPM data)
sudo tpm2_clear

# Confirm TPM is functional
sudo tpm2_selftest

# Re-enroll
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+2+7 /dev/disk/by-uuid/YOUR-LUKS-UUID

# Verify and test
sudo systemd-cryptenroll --list /dev/disk/by-uuid/YOUR-LUKS-UUID
sudo reboot
```

### Procedure C: Adjust PCR Selection

If you're getting frequent breaks due to updates:

```bash
# Remove existing enrollment
sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/disk/by-uuid/YOUR-LUKS-UUID

# Try more permissive PCR selection (less secure, more stable)
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+2 /dev/disk/by-uuid/YOUR-LUKS-UUID

# Or try with different combinations:
# --tpm2-pcrs=0        # Only firmware (most permissive)
# --tpm2-pcrs=0+7      # Firmware + Secure Boot
# --tpm2-pcrs=0+2+4+7  # Most restrictive (breaks easily)
```

### Procedure D: Hardware Changes

If you've changed hardware (RAM, storage, etc.):

```bash
# Check if new hardware is detected
lspci | grep -i tpm
dmesg | grep -i tpm

# If TPM is still present, try standard re-enrollment
sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/disk/by-uuid/YOUR-LUKS-UUID
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+2+7 /dev/disk/by-uuid/YOUR-LUKS-UUID
```

## Emergency Recovery

### If TPM is Completely Broken

```bash
# System will still boot with password - TPM is just for convenience
# Boot normally and enter your LUKS password

# Check if TPM hardware is still present
ls /dev/tpm* || echo "No TPM devices found"

# If no TPM devices, check BIOS settings:
# 1. Reboot and enter UEFI/BIOS
# 2. Look for "Security" → "TPM" or "Trusted Computing"
# 3. Ensure TPM is "Enabled"
# 4. Save and reboot

# After re-enabling TPM in BIOS:
sudo nixos-rebuild switch  # Reload TPM modules
sudo reboot
# Then follow Procedure B above
```

### If You Can't Remember LUKS Password

⚠️ **This is unrecoverable** - the whole point of encryption is that data is inaccessible without the password. Always keep a secure backup of your LUKS password.

## Prevention and Best Practices

### Regular Maintenance

```bash
# Create a monthly check script
#!/bin/bash
echo "=== TPM Status Check ==="
sudo tpm2_selftest && echo "✅ TPM functional" || echo "❌ TPM problem"

echo "=== LUKS Enrollments ==="
sudo systemd-cryptenroll --list /dev/disk/by-uuid/YOUR-LUKS-UUID

echo "=== Test Auto-unlock ==="
echo "Reboot to test auto-unlock, or check systemd boot logs:"
echo "sudo journalctl -b | grep -i luks"
```

### Before Major Updates

```bash
# Before firmware updates:
# 1. Note current PCR values
sudo tpm2_pcrread > /tmp/pcr-before-update.txt

# 2. Ensure you remember your LUKS password
# 3. After firmware update, compare PCRs:
sudo tpm2_pcrread > /tmp/pcr-after-update.txt
diff /tmp/pcr-before-update.txt /tmp/pcr-after-update.txt

# 4. If different, re-enroll TPM
```

### Alternative: Add PIN for Hybrid Security

```bash
# Remove TPM-only enrollment
sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/disk/by-uuid/YOUR-LUKS-UUID

# Add TPM + PIN (shorter than full password, more secure than TPM-only)
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+2+7 --tpm2-with-pin=yes /dev/disk/by-uuid/YOUR-LUKS-UUID

# System will prompt for PIN instead of full password
# PIN is stored in TPM, so still hardware-bound
```

## Quick Reference Commands

```bash
# Check status
sudo systemd-cryptenroll --list /dev/disk/by-uuid/UUID

# Standard re-enrollment  
sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/disk/by-uuid/UUID
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+2+7 /dev/disk/by-uuid/UUID

# Emergency TPM reset
sudo tpm2_clear
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+2+7 /dev/disk/by-uuid/UUID

# Check why unlocking might fail
sudo journalctl -b | grep -i "luks\|crypt\|tpm"
```

## Success Indicators

✅ **After recovery:**

- ```systemd-cryptenroll --list``` shows TPM2 slot active
- System boots without password prompt
- Password fallback still works when TPM is disabled

Remember: Password fallback is always available, so you can never be completely locked out of your system!
