FROM ocaml/opam2:latest

RUN opam update
RUN opam depext -i core
RUN opam install dune
RUN opam install ppx_deriving
RUN opam install shexp
