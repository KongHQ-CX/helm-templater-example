FROM golang:1.17-buster

RUN adduser --system --group tools && \
    mkdir /data && \
    chown -R tools:tools /data

COPY utils.sh /usr/local/bin/utils.sh
RUN chmod +x /usr/local/bin/utils.sh

WORKDIR /data
COPY . .
RUN CGO_ENABLED=0 go build -o /usr/local/bin/kongtemplater && \
    rm -rf /data/*

# Get kubectl
RUN wget https://dl.k8s.io/release/v1.24.0/bin/linux/amd64/kubectl && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/kubectl

# Get Helm
RUN wget https://get.helm.sh/helm-v3.9.3-linux-amd64.tar.gz && \
    tar xzvf helm-v3.9.3-linux-amd64.tar.gz && \
    chmod +x linux-amd64/helm && \
    mv linux-amd64/helm /usr/local/bin/helm

USER tools

ENTRYPOINT [ "/usr/local/bin/utils.sh" ]
