FROM node:20.0.0-bullseye

COPY ./index.js /root/
COPY ./package.json /root/

ENV TZ='<UTC>-8' 

# 根据 architecture 复制指定可执行文件到 workdir
RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
   && sed -i 's/security.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
   && sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
   && sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
   # 增加一些命令的别名
   && echo "alias ll='ls -Alh --color=auto'" >> ~/.bashrc \
   && echo "alias l='ls -Alh --color=auto'" >> ~/.bashrc \
   && echo "alias ls='ls --color=auto'" >> ~/.bashrc \
   && touch ~/image.time.$(date +"%Y-%m-%d_%H.%M.%S").build \
   && export IMAGE_BUILD_TIME=`date +"%Y-%m-%d %H:%M:%S"` \
   && apt-get update -y \
   # 可执行选择安装程序和依赖
   && apt-get install -y vim iputils-ping net-tools telnet lsof htop less unzip curl wget procps psmisc dnsutils \
   # 安装后的清理现场, 瘦身镜像
   && apt-get clean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/* \
   # vim 禁用 .swp
   && echo "set noswapfile" >> ~/.vimrc \
   && echo "imap jk <ESC>" >> ~/.vimrc \
   && echo "noremap H ^" >> ~/.vimrc \
   && echo "noremap L $" >> ~/.vimrc \
   && echo "set ignorecase smartcase" >> ~/.vimrc \
   # vim 启用行号
   && echo "set nu" >> ~/.vimrc  \
   # vim 远程配置文件
   && curl --connect-timeout 1 --max-time 10  --retry-max-time 10 --retry 3 --retry-delay 1 --retry-connrefused --retry-all-errors --silent https://request.flysay.com/https://raw.githubusercontent.com/amix/vimrc/master/vimrcs/basic.vim  >> ~/.vimrc \
   && curl --connect-timeout 1 --max-time 10  --retry-max-time 10 --retry 3 --retry-delay 1 --retry-connrefused --retry-all-errors --silent https://request.flysay.com/https://raw.githubusercontent.com/chenset/vimrc/master/.vimrc >> ~/.vimrc


WORKDIR /root/

CMD ["node", "--watch", "index.js"]

# docker build . -f nodejs-bullseye.Dockerfile -t registry.cn-shenzhen.aliyuncs.com/llll/node-api:latest
# docker push registry.cn-shenzhen.aliyuncs.com/llll/node-api:latest
