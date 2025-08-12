
oc delete -f ./team-a-ray-cluster-a.yaml -f ./team-b-ray-cluster-b.yaml -f ./team-c-ray-cluster-c.yaml
oc delete -f ./team-a-cq.yaml -f ./team-b-cq.yaml -f ./team-c-cq.yaml
oc delete -f ./team-a-local-queue.yaml -f ./team-b-local-queue.yaml	-f ./team-c-local-queue.yaml	
oc delete -f ./default-flavor.yaml -f ./gpu-flavor.yaml
oc delete -f ./team-a-rb.yaml -f ./team-b-rb.yaml -f ./team-c-rb.yaml
oc delete -f ./team-a-ns.yaml -f ./team-b-ns.yaml -f ./team-c-ns.yaml

echo "Deleting all clusterqueues"
oc delete clusterqueue --all --all-namespaces 

echo "Deleting all resourceflavors"
oc delete resourceflavor --all --all-namespaces 
	
