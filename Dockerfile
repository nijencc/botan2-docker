FROM alpine

MAINTAINER NijenCC (https://github.com/nijencc)

ARG BOTAN_REPO="https://github.com/randombit/botan"
ARG BOTAN_MINOR_AND_PATCH="17.3"

# Get packages for build and prepare python
RUN apk update && \
    apk add --no-cache \
        build-base bzip2-dev git libgcc libstdc++ musl python3 xz-dev zlib-dev && \
    ln -s /usr/bin/python3 /usr/bin/python

# Clone, configure, build and install botan (do cleanup afterwards)
RUN git clone -b "2.${BOTAN_MINOR_AND_PATCH}" "${BOTAN_REPO}" botan2 && cd botan2 && \
    ./configure.py --module-policy=modern --build-targets="static,cli" --with-bzip2 --with-lzma --with-zlib &&\
    make -j$(nproc) && make install && \
    cd .. && rm -rf botan2

# Cleanup
RUN apk del build-base git libgcc python3 && \
    rm -rf /var/cache/apk/* /usr/bin/python

ENTRYPOINT ["botan"]
