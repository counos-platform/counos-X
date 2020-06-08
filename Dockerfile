FROM debian:stable-slim

MAINTAINER Iman  Mousavi <irwebuniq@gmail.com>

ARG USER_ID
ARG GROUP_ID

ENV HOME /counosx

# ENV BDB_VERSION="db-4.8.30.NC" \
#     BDB_HASH="12edc0df75bf9abd7f82f821795bcee50f42cb2e5f76a6a281b85732798364ef" \
#     BDB_DIR="/usr/local/db4"



# add user with specified (or default) user/group ids
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}


COPY  --from=lncm/berkeleydb:v4.8.30.NC  /opt/db4  /usr/local/
RUN ln -s /usr/local/lib/libdb-4.8.so /usr/lib/libdb-4.8.so
RUN ln -s /usr/local/lib/libdb_cxx-4.8.so /usr/lib/libdb_cxx-4.8.so

ENV BDB_INCLUDE_PATH="/usr/local/include"
ENV BDB_LIB_PATH="/usr/lib/lib"

# 





RUN useradd -r counosx \
  && apt-get update -y \
  && apt-get install -y curl gnupg autoconf

RUN apt-get update -y \
	&& apt-get install -y libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev  \
	&& apt-get install -y libqt4-dev libprotobuf-dev protobuf-compiler libqrencode-dev  \
	&& apt-get install -y libminiupnpc-dev  \
	&& apt-get install -y build-essential libtool autotools-dev autoconf pkg-config libssl-dev libdb-dev libdb++-dev libevent-dev \
  	&& apt-get install -y  libzmq3-dev libcurl4-openssl-dev \
  	&& apt-get clean \
  	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


ENV GOSU_VERSION=1.10

WORKDIR $HOME
COPY . $HOME


RUN /counosx/autogen.sh 
RUN /counosx/configure --disable-tests --disable-bench --without-gui  --with-incompatible-bdb
RUN make
RUN make install


EXPOSE 9333

ENTRYPOINT ["docker-entrypoint.sh"]
