FROM python:3.7.3-slim-stretch

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

# Install postgres (psql) client
RUN apt-get install wget gzip -y
RUN wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add -
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
RUN apt-get update -y && apt-get install -y postgresql postgresql-contrib

WORKDIR /ta-lib
# numpy needs to be installed before TA-Lib
RUN pip3 install 'numpy==1.16.2' \
  && ./configure --prefix=/usr \
  && make \
  && make install \
  && pip3 install 'TA-Lib==0.4.17'

RUN cd .. && rm -rf ta-lib/