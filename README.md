# Student VM Image

This repository builds a VirtualBox VM image configured for red rocks community
college's computer architecture and assembly course. Noteably, the VM is able to
run armv7 and x86-64 assembly.

## Building

To build the VirtualBox OVA file locally:

```bash
nix build 
```

The built OVA file will be available in the `result/` directory

### Build Requirements

- Nix package manager with flakes support
- Sufficient system resources (see Known Issues below)

## Importing to VirtualBox

1. Open VirtualBox
2. Go to **File** > **Import Appliance**
3. Select the built OVA file
4. Click **Import**

Once imported, start the VM and log in with the default credentials configured in the system.

## Known Issues

### Memory Resource Race Condition

There is a known race condition during the OVA build process related to memory resource allocation. This can cause builds to fail intermittently.

**Workaround:**
- Rebuild if the build fails due to memory issues

### GitHub Runner Storage Limitations

The storage space required to build the disk image exceeds what is available on GitHub-hosted runners (~14GB free space). This prevents the CI/CD pipeline from successfully building the image.

**Future Improvement:**
- Self-hosted runners with more disk space, or
- Disk cleanup optimizations to reduce build footprint, or
- Smaller base image configuration

