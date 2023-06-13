FROM debian:oldstable-20230522

ARG EXEABLE_FILE='docker-build-会传参进来覆盖'
ENV EXEABLE_FILE ${EXEABLE_FILE}

ARG WORK_DIR='/root/'
ENV WORK_DIR ${WORK_DIR}

ARG TEMP_EXEABLE_DIR='/tmp/exeable/'
ARG EXEABLE_FILE_PATH=${WORK_DIR}app

COPY ./${EXEABLE_FILE}.* ${TEMP_EXEABLE_DIR}

# COPY ./${EXEABLE_FILE}.amd64 ${WORK_DIR}${EXEABLE_FILE}

ENV TZ='<UTC>-8' 

# 根据 architecture 复制指定可执行文件到 workdir
RUN arch='amd64' \
   && mv -f ${TEMP_EXEABLE_DIR}${EXEABLE_FILE}.$arch ${EXEABLE_FILE_PATH} \
   && rm -rf ${TEMP_EXEABLE_DIR}

WORKDIR ${WORK_DIR}

CMD ["/root/app"]
