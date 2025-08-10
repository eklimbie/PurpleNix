# NixOS TPM Encryption Quick Reference

_Created by Claude AI._

## 🔧 Essential Commands

```bash
# Find your LUKS UUID
sudo blkid | grep crypto_LUKS

# Check current enrollments
sudo systemd-cryptenroll --list /dev/disk/by-uuid/YOUR-UUID

# Standard TPM fix (90% of cases)
sudo systemd-cryptenroll --wipe-slot=tmp2 /dev/disk/by-uuid/YOUR-UUID
sudo systemd-cryptenroll --tpm2-device=auto --tmp2-pcrs=0+2+7 /dev/disk/by-uuid/YOUR-UUID

# Emergency TPM reset
sudo tmp2_clear
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+2+7 /dev/disk/by-uuid/YOUR-UUID
```

## 🚨 Quick Diagnostics

```bash
# TPM working?
sudo tpm2_selftest

# TPM devices present?
ls /dev/tpm*

# Why didn't it auto-unlock?
sudo journalctl -b | grep -i "luks\|crypt\|tpm"
```

## ⚙️ Essential NixOS Config

```nix
{
  # Required for TPM
  security.tpm2.enable = true;
  boot.initrd.systemd.enable = true;
  
  # LUKS device (NO fallbackToPassword with systemd!)
  boot.initrd.luks.devices."enc" = {
    device = "/dev/disk/by-uuid/YOUR-UUID";
    allowDiscards = true;
  };
  
  # TPM tools
  environment.systemPackages = [ pkgs.tpm2-tools pkgs.tpm2-tss ];
  environment.sessionVariables.TPM2TOOLS_TCTI = "device:/dev/tpmrm0";
}
```

## 🔄 Common PCR Options

```bash
# Most permissive (rarely breaks)
--tpm2-pcrs=0+2

# Recommended default
--tpm2-pcrs=0+2+7

# Most secure (breaks on updates)
--tpm2-pcrs=0+2+4+7

# With PIN (good middle ground)
--tpm2-pcrs=0+2+7 --tpm2-with-pin=yes
```

## 🆘 Emergency Situations

| Problem | Solution |
|---------|----------|
| **System asks for password** | Normal! Enter LUKS password, fix TPM later |
| **After firmware update** | Run standard TPM fix commands above |
| **Hardware changes** | Try standard fix, may need `tpm2_clear` first |
| **No `/dev/tpm*` devices** | Enable TPM in BIOS/UEFI settings |
| **`tpm2` commands fail** | Check `TPM2TOOLS_TCTI` environment variable |

## 📋 Installation Checklist

- [ ] TPM 2.0 enabled in BIOS
- [ ] UEFI boot mode
- [ ] `boot.initrd.systemd.enable = true` in config
- [ ] No `fallbackToPassword = true` in LUKS config
- [ ] TPM enrollment after first boot
- [ ] Test reboot for auto-unlock

## 🔍 Troubleshooting Quick Checks

```bash
# 1. TPM hardware OK?
ls /dev/tpm* && sudo tpm2_selftest

# 2. What's enrolled?
sudo cryptsetup luksDump /dev/disk/by-uuid/YOUR-UUID | grep "Key Slot"

# 3. Environment OK?
echo $TPM2TOOLS_TCTI

# 4. Recent boot logs
sudo journalctl -b -u systemd-cryptsetup@enc.service
```

## 💡 Pro Tips

- **Always works**: LUKS password bypass - you can't lock yourself out
- **After firmware updates**: Usually just need to re-enroll TPM
- **Moving drives**: TPM keys are hardware-bound, need re-enrollment
- **Backup**: Keep LUKS password in password manager - it's your master key
- **Testing**: `sudo reboot` is the ultimate test

## 🎯 Most Common Fix (Copy & Paste)

```bash
# Replace YOUR-UUID with actual UUID from blkid command
UUID="YOUR-UUID-HERE"
sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/disk/by-uuid/$UUID
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+2+7 /dev/disk/by-uuid/$UUID
sudo reboot
```

---
**Remember**: If all else fails, your LUKS password always works! 🔐
