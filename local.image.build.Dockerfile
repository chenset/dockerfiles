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
RUN arch=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) \
   && mv -f ${TEMP_EXEABLE_DIR}${EXEABLE_FILE}.$arch ${EXEABLE_FILE_PATH} \
   && rm -rf ${TEMP_EXEABLE_DIR} \
   # 替换系统 APT 源为阿里云
   && sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
   && sed -i 's/security.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
   && sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
   && sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
   # 增加一些命令的别名
   && echo "alias ll='ls -Alh --color=auto'" >> ~/.bashrc \
   && echo "alias l='ls -Alh --color=auto'" >> ~/.bashrc \
   && echo "alias ls='ls --color=auto'" >> ~/.bashrc \
   && touch ~/image.time.$(date +"%Y-%m-%d_%H.%M.%S").build \
   && export IMAGE_BUILD_TIME=`date +"%Y-%m-%d %H:%M:%S"` \
   # vim 禁用 .swp
   && echo "set noswapfile" >> ~/.vimrc \
   && echo "imap jk <ESC>" >> ~/.vimrc \
   && echo "noremap H ^" >> ~/.vimrc \
   && echo "noremap L $" >> ~/.vimrc \
   && echo "set ignorecase smartcase" >> ~/.vimrc \
   # vim 启用行号
   && echo "set nu" >> ~/.vimrc

WORKDIR ${WORK_DIR}

CMD ["/root/app"]
