
FROM ubuntu:18.04
USER root

# --->
# ---> Update the packages within this machine and create a user
# ---> that can run linkchecker with minimal privileges.
# --->

RUN apt-get update && \
    apt-get --assume-yes install -qq -o=Dpkg::Use-Pty=0 \
      curl        \
      python3-pip \
      wget


# --->
# ---> Set /root/kops as the location for entrypoint execution.
# --->

RUN mkdir -p /root/kops
WORKDIR /root/kops


# --->
# ---> install the AWS Cli and both the kops and kubectl binaries
# --->

RUN pip3 --version && \
    pip3 install awscli --upgrade pip && \
    aws --version && \
    curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64 && \
    chmod +x kops-linux-amd64 && \
    mv kops-linux-amd64 /usr/local/bin/kops && \
    kops version && \
    curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl


# --->
# ---> Copy in the kubernetes administration public key.
# --->

RUN mkdir -p /root/.ssh
COPY k8s-admin-key.pub /root/.ssh/id_rsa.pub
