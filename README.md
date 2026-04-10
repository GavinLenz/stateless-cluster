# Stateless Cluster

## Overview

This project explores stateless compute node provisioning and runtime execution using OpenCHAMI on bare-metal infrastructure. The focus is on building a reproducible, image-based cluster where nodes boot via PXE and execute workloads at runtime.

The current system demonstrates a working pipeline for air-gapped container execution across multiple compute nodes.
> See branches for ongoing experiments and iterations.

> The cluster uses the standard OpenCHAMI demo configuration as a baseline. Effort is intentionally focused on system behavior, reproducibility, and runtime workflows rather than renaming or restructuring the default environment.


---

## Architecture

```
bare metal
  → PXE / iPXE
  → OpenCHAMI (BSS, SMD, DNS)
  → image-based boot (Rocky 9)
  → cloud-init
  → Podman runtime
  → internal registry
  → container execution on compute nodes
```

---

## Repository Structure

```
desired-state/   → declarative cluster configuration
scripts/         → lifecycle operations (apply, build, snapshot, validate)
snapshots/       → timestamped cluster state (latest preserved)
logs/            → validation output
```

---

## Workflow

```
snapshot.sh  → capture current cluster state
apply.sh     → sync desired-state
build.sh     → build images (OpenCHAMI image-builder)
validate.sh  → verify cluster behavior across nodes
```

Typical cycle:

1. Modify `desired-state/`
2. Run `scripts/apply.sh` / `scripts/build.sh`
3. Reboot nodes
4. Run `scripts/validate.sh`

---

## Current Capability

* PXE-provisioned stateless compute nodes
* Cloud-init-driven initialization
* Air-gapped container workflow

  * images mirrored to internal registry
  * nodes pull and execute via Podman
* Distributed validation across nodes

Example output (see logs/example.log):

```
[INFO] Wed Apr  8 02:54:30 PM EDT 2026 starting node check
=== de01 ===
[INFO] starting
Trying to pull 172.16.0.254:5000/demo/ubi9:latest...
...
NODE=de01
Red Hat Enterprise Linux release 9.7 (Plow)
[INFO] runtime=3s
[INFO] done
[INFO] de01 OK
...
[INFO] Wed Apr  8 02:54:30 PM EDT 2026 completed node check
```

---

## Direction

Planned areas of exploration:

* Networked storage (currently NFS) 
* Container-first runtime models (quadlets / systemd integration)
* Image-based rollback and versioning strategies
* Workload orchestration across nodes
* Performance and startup latency analysis
* Transition toward fully immutable compute nodes
* Custom dracut-based boot workflows to control early userspace, networking, and container runtime handoff
