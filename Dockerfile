FROM debian:bullseye
ENV DEBIAN_FRONTEND noninteractive

COPY scripts/build_bela.sh \
	scripts/build_packages.sh \
	scripts/build_env.sh \
	scripts/build_settings \
	./

RUN ./build_packages.sh
RUN ./build_bela.sh 
RUN ./build_env.sh

CMD /bin/bash
