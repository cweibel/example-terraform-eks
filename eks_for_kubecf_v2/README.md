This is a simple terraform repo to deploy a small eks cluster.

This `_v2` version does the install of KubeCF but requires you to set the `system_domain` variable in `cluster.tf`


To summarize:

1. populate the `provider.tf` with aws.
2. fill in the cluster info in `cluster.tf`, including the `system_domain`.
3. Run `terraform init` and `terraform apply`.


## Installing KubeCF

This will be done for you now by the presence of `install_kubecf.tf`

Both the CF Operator and KubeCF will be installed via Helm.

Since the KubeCF install is asyncronous (like a `bosh deploy`) you can spend the 20 minutes required to register the DNS (next step).


Get the `A` record:

```
kubectl get service router-public -n kubecf

kubecf        router-public                  LoadBalancer   172.20.201.49    ade1d987e8b4c4a37a3d05782ff2667b-1637440588.us-west-2.elb.amazonaws.com   80:30086/TCP,443:32627/TCP                                                                                                                                     18m
```

### Register DNS

Then use CloudFlare or your DNS of choice to CNAME map the `A` record above to the `system_domain`.  In my example I use CloudFlare to map `ade1d987e8b4c4a37a3d05782ff2667b-1637440588.us-west-2.elb.amazonaws.com` to `system.kubecf.lab.starkandwayne.com`

### Log into CF

There is now a script in the `artifacts/` folder which will do the login and create a new org and space which will be targetted.  Run this in the root of the terraform folder by:

```
./artifcats/cf_login.sh
```