FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install -y vim build-essential gcc git wget openssh-server sudo htop

RUN cd $(mktemp -d) && \
      wget https://go.dev/dl/go1.18.4.linux-amd64.tar.gz && \
      rm -rf /usr/local/go && \
      tar -C /usr/local -xzf go1.18.4.linux-amd64.tar.gz

RUN useradd --create-home --shell /bin/bash mike
RUN echo 'export PATH=$PATH:/usr/local/go/bin' >> /home/mike/.bashrc

USER mike
WORKDIR /home/mike
RUN git clone https://github.com/mtlynch/picoshare.git
RUN cd picoshare && \
    git checkout repro-temp-file && \
    /usr/local/go/bin/go build --tags 'dev' -o /dev/null cmd/picoshare/main.go

CMD tail -f /dev/null
