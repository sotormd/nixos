{ config, ... }:

{
  # linux kernel parameters
  boot.kernelParams = [
    # systemd machine id
    "systemd.machine_id=${config.vars.device.machineId}"

    # disables merging of slabs of similar sizes
    # sometines, vulnerable slabs may be merged with safe ones
    # slight increase in kernel memory utilization
    "slab_nomerge"

    # enable zeroing of memory during allocation and free time
    # mitigate use-after-free vulnerabilities and erase sensitive data
    # also enables poisoning for some freed memory
    # little performance cost
    "init_on_alloc=1"
    "init_on_free=1"

    # randomises page allocator freelists
    # makes page allocations less predictable
    # slightly improves performace
    "page_alloc.shuffle=1"

    # enable kernel page table isolation
    # mitigates meltdown and prevents some KASLR bypasses
    "pti=on"

    # randomize kernel stack offset on each syscall
    # mitigates attacks reliant on deterministic kernel stack layouts
    "randomize_kstack_offset=on"

    # disable obsolete vsyscalls
    # replaced by vDSO calls
    "vsyscall=none"

    # debugfs exposes sensitive kernel information
    "debugfs=off"

    # some kernel exploits will cause an "oops"
    # this will cause the kernel to panic on such oopses, preventing the exploit
    # sometimes, bad drivers cause harmless oopses, resulting in system crashes
    "oops=panic"

    # only allows kernel modules that have been signed with a valid key to be loaded
    # makes it harder to load a malicious kernel module
    # virtualbox, nvidia modules may need manual signing
    "module.sig_enforce=1"

    # enable the kernel lockdown LSM
    # confidentiality is the strictest mode
    # protects both kernel integrity and prevents unauthorized access to kernel data
    # establishes clear security boundary between userspace and kernel
    # this implies module.sig_enforce=1
    "lockdown=confidentiality"

    # kernel will panic on uncorrectable memory errors
    # mainly for systems with ECC memory
    "mce=0"

    # mitigate spectre vulnerabilities
    "spectre_v2=on"
    "spec_store_bypass_disable=on"

    # do not trust the proprietary cpu RNG
    # this RNG can not be audited
    "random.trust_cpu=off"
    "random.trust_bootloader=off"

    # enable IOMMU
    # mitigates direct memory access attacks
    "intel_iommu=on"
    "amd_iommu=on"

    # fixes a hole in IOMMU
    # disables busmaster bit on all PCI bridges in early boot
    "efi=disable_early_pci_dma"

    # forces KVM to mark huge pages as non-executable
    # prevents code execution in certain memory regions
    # can increase memory usage, especially with KVM-based hypervisors
    "kvm.nx_huge_pages=force"

    # disable hyperthreading - for both amd and intel
    # also disable TSX and mitigate TAA - mostly for intel
    # also mitigate speculative execution vulnerabilities - mostly for intel
    # dramatic performance losses
    #"nosmt=force"
    #"tsx=off"
    #"tsx_async_abort=full,nosmt"
    #"l1tf=full,force"
    #"mds=full,nosmt"
  ];
}
