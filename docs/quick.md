### _This is intended as a reference for when updating compute's image/cloud-init quickly. This is not a full guide._

## Apply Configuration
_From desired-state/_

    ./scripts/apply.sh


## Rebuild image (compute in this case)

    ./scripts/build.sh desired-state/images/compute-base.yaml


## Validate Cluster

_Once nodes have rebooted_

    ./scripts/validate.sh