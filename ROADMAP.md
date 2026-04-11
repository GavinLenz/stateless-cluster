# ROADMAP.md

> This roadmap is iterative and subject to change. It reflects my current understanding as I explore stateless cluster architecture.

---

## Goals

### Current State

* i7 (the name of current controller) acts as a controller + storage + development node
* This is temporary for bootstrapping only

### Target State

* Roles fully separated:

  * Laptop → controller
  * i7 → storage
  * Developer workstation → external client

---

### Controller (stateful)

* Serve configs/images (OpenCHAMI)

### Storage (stateless image, stateful disks)

* Mount local NVMe/HDD
* Serve NFS

### Compute (fully stateless)

* Boot from controller
* Mount storage directly
* Execute workloads only

### Developer (stateful, external)

* Build images / containers
* Push artifacts to controller
* **Not part of cluster**

---

## Phase 0 — Bootstrap (Current state)

* Use i7 as:

  * temporary controller
  * temporary storage
* Goal: reduce variables, enable fast iteration

---

## Phase 1 — Validate Storage (Manual)

* Configure NFS on i7
* Export test directory
* From compute nodes:

  * manually mount NFS
  * test read/write

---

## Phase 2 — Integrate cloud-init

* Add cloud-init for compute nodes:

  * automatically mount NFS from i7
* Boot compute nodes via controller
* Verify nodes mount on boot

---

## Phase 3 — Build Storage Image

* Use a compute node as build base
* Create storage image with:

  * NFS server
  * disk mounts

> Goal: image/cloud-init work without manual intervention

---

## Phase 4 — Deploy Controller (Laptop)

* Move controller to laptop 
* Responsibilities:

  * image serving
  * OpenCHAMI control

---

## Phase 5 — Reprovision Storage

* Wipe i7 completely
* Deploy using storage image

---

## Phase 6 — Full System Validation

* Boot compute nodes via controller
* Compute nodes mount storage directly
* Run test workload

---

## End State

* Stateless compute nodes
* Image-defined storage node
* Minimal controller
* External developer workflow

---

### Next steps (will be updated)

* Slurm integration