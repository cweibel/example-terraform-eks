This is a simple terraform repo to deploy a small eks cluster.

This cluster is a bit different than the original `eks` cluster in that the amount of disk needed has been increased from 20GB to 50GB.  This is because of the error:

```
kubectl logs diego-cell-0 -c bpm-pre-start-garden -n kubecf
+ /var/vcap/jobs/garden/bin/bpm-pre-start
find: cannot delete '/var/vcap/data/grootfs/store': Device or resource busy
find: cannot delete '/var/vcap/data/grootfs/': Directory not empty
2020-10-20T19:15:12.419065411Z - running thresholder
The node running this cell doesn't have enough disk space. You requested 40960M but the disk is 20468M in size.
```

This does work with a Fargate Profile defined but omitted since it isn't needed.

Built using [this terraform module](https://github.com/FairwindsOps/terraform-vpc) based on [this blog post](https://www.fairwinds.com/blog/terraform-and-eks-a-step-by-step-guide-to-deploying-your-first-cluster).

To summarize:

1. populate the `provider.tf` with aws.
2. fill in the cluster info in `cluster.tf`.
3. give it the `terraform init` and `apply`.

Once that is done, get the eks cluster into your kubeconfig with:

    $ aws eks --region us-west-2 update-kubeconfig --name my-eks-cluster


## Installing KubeCF

Once the EKS cluster in this subfolder is deployed, installing KubeCF is done via two Helm commands.  Note that the second one requires you to add your own values for `system_domain`.  Don't use mine, I've already used it!

```
kubectl create namespace cf-operator

helm install cf-operator \
--namespace cf-operator \
--set "global.singleNamespace.name=kubecf" \
https://github.com/cloudfoundry-incubator/quarks-operator/releases/download/v6.1.17/cf-operator-6.1.17+0.gec409fd7.tgz


helm install kubecf \
  --namespace kubecf \
  --set system_domain=system.kubecf.lab.starkandwayne.com \
https://github.com/cloudfoundry-incubator/kubecf/releases/download/v2.5.8/kubecf-v2.5.8.tgz
```

Get the `A` record:

```
kubectl get services -A | grep " router-public"

kubecf        router-public                  LoadBalancer   172.20.201.49    ade1d987e8b4c4a37a3d05782ff2667b-1637440588.us-west-2.elb.amazonaws.com   80:30086/TCP,443:32627/TCP                                                                                                                                     18m
```

### Register DNS

Then use CloudFlare or your DNS of choice to CNAME map the `A` record above to the `system_domain`.  In my example I use CloudFlare to map `ade1d987e8b4c4a37a3d05782ff2667b-1637440588.us-west-2.elb.amazonaws.com` to `system.kubecf.lab.starkandwayne.com`

### Log into CF

```
cf api --skip-ssl-validation "https://api.system.kubecf.lab.starkandwayne.com"

admin_pass=$(kubectl get secret \
        --namespace kubecf var-cf-admin-password \
        -o jsonpath='{.data.password}' \
        | base64 --decode)

cf auth admin "${admin_pass}"
```
