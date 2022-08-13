FROM golang:1.17-buster

RUN adduser --system --group tools && \
    mkdir /data && \
    chown -R tools:tools /data

WORKDIR /tmp
RUN go get github.com/tsg/gotpl && \
    wget https://github.com/mikefarah/yq/releases/download/v4.27.2/yq_linux_amd64 && \
    mv yq_linux_amd64 /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq

COPY utils.sh /usr/local/bin/utils.sh
RUN chmod +x /usr/local/bin/utils.sh

WORKDIR /data
USER tools

ENTRYPOINT [ "/usr/local/bin/utils.sh" ]
