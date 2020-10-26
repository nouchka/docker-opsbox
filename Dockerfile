FROM alpine:latest
##https://github.com/helm/helm/releases
ENV HELM_VERSION v3.4.0
##https://storage.googleapis.com/kubernetes-release/release/stable.txt
ENV KUBECTL_VERSION v1.19.3

RUN apk update \
    && apk add --no-cache  bash bash-completion coreutils curl gcc git \
    jq less libc6-compat libffi-dev make musl-dev openssl openssh-client \
    openssl-dev sshpass tar unzip vim && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /etc/bash_completion.d/ /etc/profile.d/

# Install kubectl
RUN curl -L -o /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x /usr/bin/kubectl && \
    kubectl completion bash > /etc/bash_completion.d/kubectl.sh

# Install helm
RUN wget -q https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
  && chmod +x /usr/local/bin/helm


COPY start.sh /start.sh

RUN chmod +x /start.sh && \
    mkdir /mnt/opsbox && \
    ln -s /mnt/opsbox/.kube /root/.kube

WORKDIR /opsbox

VOLUME ["/opsbox", "/mnt/opsbox"]

ENTRYPOINT ["/start.sh"]
