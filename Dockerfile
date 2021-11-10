# Pin the base image to a specific hash for maximum reproducibility.
# It will probably still work on newer images, though, unless an update
# changes some compiler optimisations (unlikely).
#FROM ocurrent/opam:fedora-32-ocaml-4.11
FROM ocurrent/opam@sha256:fce44a073ff874166b51c33a4e37782286d48dbba1b5aa43563a0dd35d15510f

# Pin last known-good version for reproducible builds.
# Remove this line (and the base image pin above) if you want to test with the
# latest versions.
RUN cd ~/opam-repository && git fetch origin master && git reset --hard 87ef72b5cd492573258eb1b6f3b30c88af31ae3f && opam update

RUN opam depext -i -y mirage
RUN mkdir /home/opam/qubes-mirage-firewall
ADD config.ml /home/opam/qubes-mirage-firewall/config.ml
WORKDIR /home/opam/qubes-mirage-firewall
RUN opam config exec -- mirage configure -t xen && make depend
CMD opam config exec -- mirage configure -t xen && \
    opam config exec -- make tar
