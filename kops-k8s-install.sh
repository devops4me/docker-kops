#!/bin/bash

# ++ +++ +++++++ # ++++++++ +++++++ # ++++++ +++++++++ # ++++++++++ # ++++++ +++++++ ++ #
# ++ --- ------- # -------- ------- # ------ --------- # ---------- # ------ ------- ++ #
# ++                                                                                 ++ #
# ++  Install a kubernetes cluster on the AWS cloud and enable secure cluster        ++ #
# ++  administration and management with a public/private keypair.                   ++ #
# ++                                                                                 ++ #
# ++ --- ------- # -------- ------- # ------ --------- # ---------- # ------ ------- ++ #
# ++ +++ +++++++ # ++++++++ +++++++ # ++++++ +++++++++ # ++++++++++ # ++++++ +++++++ ++ #


# --> kops delete cluster \
# -->        --state "s3://kops.kubernetes.cluster.state" \
# -->        --name lab.dublin.k8s.local \
# -->        --yes
# --> exit 0;

echo "" ; echo "" ;
echo "### ########################################################## ###"
echo "### Create the SSH administration public key as a kops secret. ###"
echo "### ########################################################## ###"
echo ""

## kops create secret sshpublickey admin.key -i /tmp/k8s-admin-key.pub \
##     --name k8s-cluster.lab.dublin \
##     --state s3://kops.kubernetes.cluster.state

####### ------> kops create secret --name lab.devopswiki.co.uk sshpublickey admin -i /tmp/k8s-admin-key.pub


echo "" ; echo "" ;
echo "### ######################################################## ###"
echo "### Create the kubernetes cluster and store the state in S3. ###"
echo "### ######################################################## ###"
echo ""

kops create cluster \
       --state "s3://kops.kubernetes.cluster.state" \
       --zones "eu-west-1a,eu-west-1b,eu-west-1c" \
       --master-count 3 \
       --master-size=t2.micro \
       --node-count 2 \
       --node-size=t2.micro \
       --name lab.dublin.k8s.local \
       --yes

#### ---> kops create cluster \
#### --->     --zones=eu-west-1a,eu-west-1b \
#### --->     --node-count=2 \
#### --->     --name lab.devopswiki.co.uk

exit 0
