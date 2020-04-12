FROM python:3.7.3-slim-stretch

RUN apt-get update

# Installing docker
RUN apt-get -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
RUN apt-get update
RUN apt-get install -y docker-ce

RUN apt-get install -y zip unzip wget
RUN apt-get install -y python3-pip git make g++
RUN pip3 install --upgrade pip
RUN pip3 install --upgrade awscli
RUN pip3 install boto3

RUN apt-get update
RUN apt-get update && apt-get install -y \
    iputils-ping \
    iproute2 \
    curl \
    gcc \
    make \
    gnupg2 \
    wget \
    && rm -rf /var/lib/apt/lists/* \
    && curl -L https://downloads.sourceforge.net/project/ta-lib/ta-lib/0.4.0/ta-lib-0.4.0-src.tar.gz | tar xvz

WORKDIR /ta-lib
# numpy needs to be installed before TA-Lib
RUN pip3 install 'numpy==1.16.2' \
  && ./configure --prefix=/usr \
  && make \
  && make install \
  && pip3 install 'TA-Lib==0.4.17'

RUN cd .. && rm -rf ta-lib/

#Install Terraform Version 0.12.23
RUN wget --quiet https://releases.hashicorp.com/terraform/0.12.23/terraform_0.12.23_linux_amd64.zip \
  && unzip terraform_0.12.23_linux_amd64.zip \
  && mv terraform /usr/bin \
  && rm terraform_0.12.23_linux_amd64.zip
