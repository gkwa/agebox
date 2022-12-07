FROM amazon/aws-lambda-python

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN yum check-update; \
    yum install -y gcc libffi-devel python3 epel-release; \
    yum install -y krb5-devel python3-devel; \
    yum install -y git tar gzip; \
    yum install -y python3-pip; \
    yum install -y wget; \
    yum clean all

RUN pip3 install --upgrade pip; \
    pip3 install --upgrade virtualenv; \
    pip3 install pywinrm[kerberos]; \
    pip3 install pywinrm; \
    pip3 install jmspath; \
    pip3 install requests; \
    python3 -m pip install ansible; \
    ansible-galaxy collection install azure.azcollection; \
    pip3 install -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements-azure.txt

RUN version=$(curl -s https://api.github.com/repos/gopasspw/gopass/releases/latest | grep -Po '"tag_name": "\K.*?(?=")' | tr -d v) && \
    echo $version && \
    curl -Lo /tmp/gopass-${version}-linux-amd64.tar.gz https://github.com/gopasspw/gopass/releases/download/v${version}/gopass-${version}-linux-amd64.tar.gz && \
    mkdir -p /tmp/gopass-${version}-linux-amd64 && \
    tar xzf /tmp/gopass-${version}-linux-amd64.tar.gz -C /tmp/gopass-${version}-linux-amd64 && \
    install -m 755 /tmp/gopass-${version}-linux-amd64/gopass /usr/local/bin/gopass && \
    gopass --version && \
    rm -rf /tmp/gopass*

RUN python --version; \
    gpg --version; \
    ansible --version; \
    ansible-galaxy --version

ENTRYPOINT ["bash"]
