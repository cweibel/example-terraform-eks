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

Built using [this terraform module](https://github.com/FairwindsOps/terraform-vpc) based on [this blog post](https://www.fairwinds.com/blog/terraform-and-eks-a-step-by-step-guide-to-deploying-your-first-cluster).

To summarize:

1. populate the `provider.tf` with aws.
2. fill in the cluster info in `cluster.tf`.
3. give it the `terraform init` and `apply`.

> Note: The blog posts starts creating an ssh key. As far as I can tell, it doesn't do anything with this key. If terraform is for whatever reason looking for it, `ssh-keygen -t rsa -f ./eks-key`

Once that is done, get the eks cluster into your kubeconfig with:

    $ aws eks --region us-west-2 update-kubeconfig --name my-eks-cluster
