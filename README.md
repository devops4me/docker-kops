
# Kops | kubectl | AWS Cli

With docker run we'll provision both a simple **`.k8s.local`** and a production grade Kubernetes cluster. The **[Dockeerfile]** takes care of installing **kops**, **kubectl** and the **AWS Cli**.

## The Todo List

- create a k8s4me user in Dockerfile
- create a docker volume and copy the public key into it
- when running create cluster mount volume and link public key file to /var/opt/k8s4me/.ssh/id_rsa.pub
- check that the volume now has a .kube folder in it
- maybe use safe to suckup the ~/.kube/config file
- clone git app deployment project
- run kubectl commands by mounting .kube/config and mounting the git deployment yamls
- possibly add ~/.kube/config file to kubernetes secrets on Jenkins stack
- now build jobs (after pushing docker image) can use kubectl container to deploy them into cluster



## Part 1 | Create a `.k8s.local` Kubernetes cluster

### Step 1a | Checklist

- clone this project | **`git clone https://github.com/devops4me/docker-kops`**
- step into the project | **`cd docker-kops`**
- create an S3 bucket to manage the kubernetes cluster state (kops.kubernetes.cluster.state)
- create a comma separated list of availability zones
- setup an AWS IAM user with the below 5 IAM permissiones
- create a RSA public/private keypair and place the public key in **`k8s-admin-key.pub`**

```
AmazonEC2FullAccess
AmazonRoute53FullAccess
AmazonS3FullAccess
IAMFullAccess
AmazonVPCFullAccess
```

### Step 1b | Create a `.k8s.local` Kubernetes Cluster

Run the docker build **after** placing the RSA public key (2048 or 4096 bits) in the **`k8s-admin-key.pub`** file. Next set the S3 bucket name, the cluster name, the default region, IAM user keys and the availability zones. Then execute the docker run statement to create the kubernetes cluster.

```
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
	   -v $PWD:/root \
	   img.kops kops create cluster --zones "eu-west-1a,eu-west-1b,eu-west-1c" --master-count 3 --master-size=t2.micro --node-count 3 --node-size=t2.micro --yes
```

### Step 1c | SSH onto a Master Node

Find the IP address or public DNS name of any master node and ssh into it like so.

```
ssh admin@<<ec2-public-dns-name>> -i /path/to/private-key.pem
```


### Step 1d | Use kubectl to manage the cluster

If you run kubectl too early you'll get a **`Unable to connect to the server: EOF`** error message.

```
docker run --rm --volume $PWD:/root img.kops kubectl get nodes -o wide
```

### Step 1e | Delete the Kubernetes cluster

We can **delete the entire VPC wrapped Kubernetes cluster** by specifying the cluster name, state s3 bucket store name and IAM user's region and access keys.

```
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
	   img.kops kops delete cluster --yes
```


## Checklist | b4 creating a production Kubernetes cluster

- clone this project | **`git clone https://github.com/devops4me/docker-kops`**
- step into the project | **`cd docker-kops`**
- register a domain name and have the hosted zone ID handy
- use **`dig NS devopswiki.co.uk`** to check access to the domain name
- create an S3 bucket to manage the kubernetes cluster state (kops.kubernetes.cluster.state)
- decide on an availability zone
- setup AWS credentials and add to the appropriate ENV variables


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
