
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
# ---> install the AWS command line interface
# --->

RUN pip3 --version && pip3 install awscli --upgrade pip && aws --version


# --->
# ---> Set /root/kops as the location for entrypoint execution.
# --->

RUN mkdir -p /root/kops
WORKDIR /root/kops


# --->
# ---> install the kops binary using curl, place it in /usr/local/bin for
# ---> visibility then give it execute permissions.
# --->

RUN curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64 && \
    chmod +x kops-linux-amd64 && \
    mv kops-linux-amd64 /usr/local/bin/kops && \
    kops version


# --->
# ---> Copy in the kubernetes administration public key and
# ---> the AWS kubernetes cluster install script.
# --->

COPY kops-k8s-install.sh .
RUN chmod u+x kops-k8s-install.sh
COPY k8s-admin-key.pub /tmp


# --->
# ---> The docker run will invokes this install script.
# --->

ENTRYPOINT [ "/root/kops/kops-k8s-install.sh" ]





# -------------> ENTRYPOINT linkchecker \
# -------------> --ignore-url=.yaml$ \
# -------------> --ignore-url=.gitignore$ \
# -------------> --ignore-url=Dockerfile$ \
# -------------> --ignore-url=Jenkinsfile$ \
# -------------> --ignore-url=^/history/* \
# -------------> --ignore-url=/[0-9a-f]{40}$ \
# -------------> --ignore-url=^https://medium.com \
# -------------> "$LINK_CHECKER_URL"

# -------------> ENTRYPOINT ["kops"]
