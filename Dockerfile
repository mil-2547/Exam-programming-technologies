FROM gcc:14

RUN apt-get update && apt-get install -y --no-install-recommends ccache g++
RUN rm -rf /var/lib/apt/lists/*

ENV CCACHE_DIR=/ccache
ENV CCACHE_BASEDIR=/workspace
ENV CCACHE_NOHASHDIR=true
ENV PATH=/usr/lib/ccache:$PATH

WORKDIR /workspace

CMD ["/bin/bash"]
