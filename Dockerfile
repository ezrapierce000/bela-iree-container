FROM debian:bullseye
ENV DEBIAN_FRONTEND noninteractive

ADD cmake/ ./cmake/
ADD iree/ ./iree/
ADD scripts/ ./scripts/

RUN ./scripts/build_packages.sh
RUN ./scripts/build_bela.sh
RUN ./scripts/build_env.sh
RUN ./scripts/build_iree.sh

CMD /bin/bash
