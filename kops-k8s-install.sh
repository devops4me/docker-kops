#!/bin/bash

# ++ +++ +++++++ # ++++++++ +++++++ # ++++++ +++++++++ # ++++++++++ # ++++++ +++++++ ++ #
# ++ --- ------- # -------- ------- # ------ --------- # ---------- # ------ ------- ++ #
# ++                                                                                 ++ #
# ++  Install a kubernetes cluster on the AWS cloud and enable secure cluster        ++ #
# ++  administration and management with a public/private keypair.                   ++ #
# ++                                                                                 ++ #
# ++ --- ------- # -------- ------- # ------ --------- # ---------- # ------ ------- ++ #
# ++ +++ +++++++ # ++++++++ +++++++ # ++++++ +++++++++ # ++++++++++ # ++++++ +++++++ ++ #


echo "" ; echo "" ;
echo "### ########################################################## ###"
echo "### Create the SSH administration public key as a kops secret. ###"
echo "### ########################################################## ###"
echo ""

kops create secret sshpublickey admin.key -i /tmp/k8s-admin-key.pub


echo ""
echo "### ########################################### ###"
echo "### List the contents of the current directory. ###"
echo "### ########################################### ###"
echo ""

ls -lah; echo "";


echo "" ; echo "" ;
echo "### ######################################################## ###"
echo "### Create the kubernetes cluster and store the state in S3. ###"
echo "### ######################################################## ###"
echo ""

kops create cluster \
    --zones=eu-west-1a,eu-west-1b \
    --node-count=2

exit 0
