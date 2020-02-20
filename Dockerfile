
FROM ubuntu:18.04
USER root

# --->
# ---> Update the packages within this machine and create a user
# ---> that can run linkchecker with minimal privileges.
# --->

RUN apt-get update && \
    apt-get --assume-yes install -qq -o=Dpkg::Use-Pty=0 \
      curl            \
      build-essential \
      libssl-dev \
      libffi-dev \
      python-dev \
      python3-pip \
      wget

# --->
# ---> install the AWS command line interface
# --->

RUN pip3 --version && pip3 install awscli --upgrade pip

# -------------> RUN apt-get update && \
# ------------->     apt-get --assume-yes install -qq -o=Dpkg::Use-Pty=0 wget && \
# ------------->     adduser --home /var/opt/checker --shell /bin/bash --gecos 'Link Checking User' checker && \
# ------------->     install -d -m 755 -o checker -g checker /var/opt/checker && \
# ------------->     usermod -a -G sudo checker


# --->
# ---> install the kops binary using curl, place it in /usr/local/bin for
# ---> visibility then give it execute permissions.
# --->

RUN curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64 && \
    chmod +x kops-linux-amd64 && \
    mv kops-linux-amd64 /usr/local/bin/kops && \
    kops version


# -------------> COPY linkcheckerrc /var/opt/checker/.linkchecker/linkcheckerrc
# -------------> COPY linkchecker_9.4.0-2_amd64.deb /tmp
# -------------> RUN apt install --assume-yes /tmp/linkchecker_9.4.0-2_amd64.deb


# --->
# ---> Now switch to the lesser permissioned checker user as
# ---> it does not like to run with unnecessary privileges.
# --->

# -------------> USER checker
# -------------> WORKDIR /var/opt/checker


# --->
# ---> Checking begins when docker run passes the source site url
# ---> in LINK_CHECKER_SITE_URL as an --env variable.
# --->

# -------------> ENTRYPOINT linkchecker \
# -------------> --ignore-url=.yaml$ \
# -------------> --ignore-url=.gitignore$ \
# -------------> --ignore-url=Dockerfile$ \
# -------------> --ignore-url=Jenkinsfile$ \
# -------------> --ignore-url=^/history/* \
# -------------> --ignore-url=/[0-9a-f]{40}$ \
# -------------> --ignore-url=^https://medium.com \
# -------------> "$LINK_CHECKER_URL"

ENTRYPOINT ["kops"]
