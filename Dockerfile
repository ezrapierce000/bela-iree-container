FROM debian:bullseye
ENV DEBIAN_FRONTEND noninteractive

ADD scripts/ ./scripts/
ADD cmake/ ./cmake/
ADD iree/ ./iree/


RUN ./scripts/build_packages.sh
RUN ./scripts/build_bela.sh
RUN ./scripts/build_env.sh

CMD /bin/bash
