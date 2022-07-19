FROM debian:bullseye
ENV DEBIAN_FRONTEND noninteractive

ADD cmake/ /home/cmake/
ADD iree/ /home/iree/

ADD scripts/build_packages.sh ./scripts/build_packages.sh
RUN ./scripts/build_packages.sh

ADD scripts/build_bela.sh ./scripts/build_bela.sh
ADD scripts/build_settings ./scripts/build_settings
RUN ./scripts/build_bela.sh

ADD scripts/build_env.sh ./scripts/build_env.sh
RUN ./scripts/build_env.sh

ADD scripts/build_iree.sh ./scripts/build_iree.sh
RUN ./scripts/build_iree.sh

CMD /bin/bash
