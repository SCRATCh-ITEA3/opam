ARG ALPINE_VERSION=latest
FROM alpine:$ALPINE_VERSION

ARG OCAML_VERISON=4.10.0
ARG OPAM_VERSION=2.0.2
RUN apk add openssl \
        git mercurial \
        alpine-sdk \
        perl m4 pkgconf \
        bubblewrap bash \
        opam 
RUN addgroup -g 1000 opam
RUN adduser -D -u 1000 opam -G opam
USER opam 
WORKDIR /home/opam
RUN opam init --disable-sandboxing -a
RUN sed -n '/opam/p' ~/.profile >/tmp/opam_init; sed -i '/opam/d' ~/.profile; 
RUN opam switch create $OCAML_VERISON
RUN eval $(opam env) && opam install -y opam-devel
USER root
RUN apk del ocaml opam 
RUN install -g root -o root -m 0777 /home/opam/.opam/$OCAML_VERISON/lib/opam-devel/opam /usr/local/bin 
RUN install -g root -o root -m 0777 /tmp/opam_init /etc/profile.d/opam
ADD dotprofile /root/.profile
USER opam
RUN opam init -a
RUN opam update
SHELL ["/bin/ash","-l","-c"]
RUN opam install -y depext
RUN opam uninstall -y -a opam-devel 
RUN opam switch $OCAML_VERISON
RUN opam switch remove default -y
RUN opam update
RUN opam upgrade
RUN opam clean
USER root
WORKDIR /home/opam
RUN rm -rf /tmp/*
CMD ["/bin/ash","-l"]

