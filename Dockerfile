FROM debian:9-slim

RUN mkdir -p /app

WORKDIR /app

SHELL ["/bin/bash", "-c"]

RUN apt update
RUN apt install automake libtool pkg-config build-essential ccache libboost-dev libboost-system-dev liblog4cplus-dev libssl-dev

RUN export PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig
RUN declare -x PATH="/usr/lib64/ccache:$PATH"

COPY . .

RUN autoreconf --install
RUN ./configure
RUN make -j4
RUN make install
RUN echo "/usr/local/lib/hooks" > /etc/ld.so.conf.d/kea.conf
RUN ldconfig

ENTRYPOINT [ "/bin/bash" ]