FROM gitpod/workspace-base:latest

ARG KUBECTL_VERSION=v1.28.1


RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    sudo mv ./kubectl /usr/local/bin/kubectl && \
    mkdir ~/.kube

RUN wget "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -O "awscliv2.zip" && \
    unzip awscliv2.zip && \
    rm -rf awscliv2.zip && \
    sudo ./aws/install --install-dir /opt/aws-cli --bin-dir /usr/local/bin/ && \
    sudo chmod a+x /opt/

RUN wget https://github.com/derailed/k9s/releases/download/v0.26.3/k9s_Linux_x86_64.tar.gz -O k9s.tar.gz && \
    tar -xvf k9s.tar.gz && \
    sudo mv ./k9s /usr/local/bin/k9s && \
    rm -rf k9s.tar.gz

RUN curl -L https://git.io/get_helm.sh | bash -s -- --version v3.8.2

RUN wget https://github.com/ahmetb/kubectx/releases/download/v0.9.5/kubectx_v0.9.5_linux_x86_64.tar.gz -O kubectx.tar.gz && \
    tar -xvf kubectx.tar.gz && \
    sudo mv ./kubectx /usr/local/bin/kubectx && \
    rm -rf kubectx.tar.gz

RUN wget https://github.com/ahmetb/kubectx/releases/download/v0.9.5/kubens_v0.9.5_linux_x86_64.tar.gz -O kubens.tar.gz && \
    tar -xvf kubens.tar.gz && \
    sudo mv ./kubens /usr/local/bin/kubens && \
    rm -rf kubectx.tar.gz
