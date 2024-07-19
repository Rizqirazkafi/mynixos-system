# My NixOS Configuration
using flake and home-manager

## Enable secure boot in qemu

1. Download ovmf_<year>_all.deb in debian repo under /debian/pool/main/e/edk2
1. extract using dpkg-deb -xv ovmf_<year>_all.deb destination
1. use under /usr/share/OVMF
1. Add these two to xml config
```xml
<os>
  <loader readonly="yes" secure="yes" type="pflash">/path/to/OVMF_CODE.secboot.fd</loader>
  <nvram>/path/to/OVMF_VARS.secboot.fd</nvram>
</os>
```

```xml
<features>
  <smm state="on"/>
</features>
```
