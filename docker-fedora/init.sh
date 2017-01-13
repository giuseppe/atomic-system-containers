#!/bin/sh

PRELOAD=$DESTDIR/usr/lib64/ld-linux-x86-64.so.2
export PATH=/var/lib/containers/atomic/docker-fedora.0/rootfs/bin:/var/lib/containers/atomic/docker-fedora.0/rootfs/sbin

# set storage first
(
        export LD_LIBRARY_PATH=/var/lib/containers/atomic/docker-fedora.0/rootfs/usr/lib64
        export PYTHONPATH=/var/lib/containers/atomic/docker-fedora.0/rootfs/usr/lib64/python2.7
        export DESTDIR=/var/lib/containers/atomic/docker-fedora.0/rootfs
        . /etc/sysconfig/docker-storage-setup
        $DESTDIR/usr/bin/docker-storage-setup
)

getent group docker || groupadd docker

source /run/$NAME/bash-env

$PRELOAD $DESTDIR/usr/libexec/docker/docker-containerd-current \
            --listen unix:///run/containerd.sock      \
            --shim $DESTDIR/usr/bin/shim.sh &

exec $PRELOAD $DESTDIR/usr/bin/dockerd-current \
             --add-runtime oci=$DESTDIR/usr/libexec/docker/docker-runc-current \
             --default-runtime=oci \
             --containerd /run/containerd.sock \
             --exec-opt native.cgroupdriver=systemd \
             --userland-proxy-path=$DESTDIR/usr/libexec/docker/docker-proxy-current \
             $OPTIONS \
             $DOCKER_STORAGE_OPTIONS \
             $DOCKER_NETWORK_OPTIONS \
             $ADD_REGISTRY \
             $BLOCK_REGISTRY \
             $INSECURE_REGISTRY
