This is a simple terraform repo to deploy a small eks cluster. An additional file called `add-fargate.tf` has been added to deploy a Fargate Profile defined so that any pods in the `default` namespace are deployed to Fargate.  Pods in any other namespace will be scheduled on one of the managed node group workers.

Built using [this terraform module](https://github.com/FairwindsOps/terraform-vpc) based on [this blog post](https://www.fairwinds.com/blog/terraform-and-eks-a-step-by-step-guide-to-deploying-your-first-cluster).

To summarize:

1. populate the `provider.tf` with aws.
2. fill in the cluster info in `cluster.tf`.
3. give it the `terraform init` and `apply`.

> Note: The blog posts starts creating an ssh key. As far as I can tell, it doesn't do anything with this key. If terraform is for whatever reason looking for it, `ssh-keygen -t rsa -f ./eks-key`

Once that is done, get the eks cluster into your kubeconfig with:

    $ aws eks --region us-west-2 update-kubeconfig --name my-eks-cluster
