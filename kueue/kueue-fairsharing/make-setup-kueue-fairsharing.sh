
oc create -f ./team-a-ns.yaml -f ./team-b-ns.yaml -f ./team-c-ns.yaml
oc create -f ./team-a-rb.yaml -f ./team-b-rb.yaml -f ./team-c-rb.yaml
oc create -f ./default-flavor.yaml -f ./gpu-flavor.yaml
oc create -f ./team-a-cq.yaml -f ./team-b-cq.yaml -f ./team-c-cq.yaml
oc create -f ./team-a-local-queue.yaml -f ./team-b-local-queue.yaml -f ./team-c-local-queue.yaml
