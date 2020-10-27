aws eks --region us-west-2 update-kubeconfig --name ${cluster_name}

kubectl create namespace cf-operator

helm install cf-operator \
--namespace cf-operator \
--set "global.singleNamespace.name=kubecf" \
https://github.com/cloudfoundry-incubator/quarks-operator/releases/download/v6.1.17/cf-operator-6.1.17+0.gec409fd7.tgz


sleep 60 # or some sort of loop that waits until all 3 cf-operator pods are healthy

helm install kubecf \
  --namespace kubecf \
  --set system_domain=${system_domain} \
https://github.com/cloudfoundry-incubator/kubecf/releases/download/v2.6.1/kubecf-v2.6.1.tgz

echo "Load Balancer which needs a DNS entry:"
kubectl get services -A | grep " router-public"