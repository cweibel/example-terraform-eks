# Hello!

This repo is full of sample Terraform code to spin EKS and other fun bits.  Each subfolder spins up a different type of EKS cluster depending on the end use case of the cluster.  For example, `eks` is just a generic cluster with 1 managed node group while `eks-for-kubecf` configures the disk needed for a successful deployment of [KubeCF](https://kubecf.io)

To deploy any of these examples set your AWS environment variables, then `cd` into the subfolder with your desired cluster type and run the terraform commands:

```
export AWS_ACCESS_KEY_ID=AKIAGETYOUROWNCREDS2
export AWS_SECRET_ACCESS_KEY=Nqo8XDD0cz8kffU234eCP0tKy9xHWBwg1JghXvM4
export AWS_DEFAULT_REGION=us-east-2

terraform init
terraform apply
```

## KubeCF on EKS

Check out the README.md in the `eks-for-kubecf` subfolder for more details, below is an aggregation of all the EKS and KubeCF blogs used as a reference to get KubeCF to live happily in EKS.

References:

 - The code in the `eks-add-fargate` is what was used in the [65 Lines of Terraform for a New VPC + EKS + Node Group + Fargate Profile](https://www.starkandwayne.com/blog/65-lines-of-terraform-for-a-new-vpc-eks-node-group-fargate-profile/) blog I wrote.
 - Dave's blog on Installing KubeCF (v0.2.0) on RKE on vSphere [https://www.starkandwayne.com/blog/cloud-foundry-on-rancher-where-to-begin/](https://www.starkandwayne.com/blog/cloud-foundry-on-rancher-where-to-begin/)
 - Modern generic kubecf install [https://kubecf.io/docs/deployment/kubernetes-deploy/](https://kubecf.io/docs/deployment/kubernetes-deploy/)
 - Using EKSCTL [https://starkandwayne.com/blog/getting-started-with-amazons-eks/](https://starkandwayne.com/blog/getting-started-with-amazons-eks/)
 - Deploying older KubeCF (v0.2.0) on EKS spun with EKSCTL: [https://www.starkandwayne.com/blog/running-cloud-foundry-on-kubernetes-using-kubecf/](https://www.starkandwayne.com/blog/running-cloud-foundry-on-kubernetes-using-kubecf/)

## Using EKSCTL

From this [blog post](https://starkandwayne.com/blog/getting-started-with-amazons-eks/) the instructions for deploying a 2 nodes kubernetes cluster with all the fixin's: vpc, subnets, IAM roles and sausage gravy.  This repo is basically the "Terraform version" of this blog.
