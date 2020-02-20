
# Kops | kubectl | AWS Cli

This docker machine provisions a Kubernetes cluster within AWS with just one command because it arrives ready with kops, klubectl, the AWS Cli and tech for creating certificates for secure intra-cluster comms.


## Before Creating the Kubernetes Cluster

- register a domain name and have the hosted zone ID handy
- use **`dig NS devopswiki.co.uk`** to check access to the domain name
- create an S3 bucket to manage the kubernetes cluster state (kops.kubernetes.cluster.state)
- decide on an availability zone
- setup AWS credentials and add to the appropriate ENV variables


## How to Create the Kubernetes Cluster

```
dig NS devopswiki.co.uk
safe login <<book.name>>
safe open kubernetes lab.dublin
docker build -t img.kops .
docker build --no-cache -t img.kops .
docker run --interactive \
           --tty \
	   --rm \
	   --name vm.kops \
	   --env KOPS_STATE_STORE=s3://kops.kubernetes.cluster.state \
	   --env KOPS_CLUSTER_NAME=lab.dublin.k8s.local \
	   --env NAME=lab.dublin.k8s.local \
	   --env AWS_DEFAULT_REGION=`safe print region.key` \
	   --env AWS_ACCESS_KEY_ID=`safe print @access.key` \
	   --env AWS_SECRET_ACCESS_KEY=`safe print @secret.key` \
	   img.kops
```

## How to Delete the Kubernetes Cluster

```
safe open kubernetes lab.dublin
docker build --no-cache -t img.kops .
docker run --interactive \
           --tty \
	   --rm \
	   --name vm.kops \
	   --env KOPS_STATE_STORE=s3://kops.kubernetes.cluster.state \
	   --env KOPS_CLUSTER_NAME=lab.dublin.k8s.local \
	   --env NAME=lab.dublin.k8s.local \
	   --env AWS_DEFAULT_REGION=`safe print region.key` \
	   --env AWS_ACCESS_KEY_ID=`safe print @access.key` \
	   --env AWS_SECRET_ACCESS_KEY=`safe print @secret.key` \
	   img.kops delete cluster --yes
```
