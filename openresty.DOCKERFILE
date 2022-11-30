# 修改默认时区必须使用 debian 系列的镜像底包
FROM openresty/openresty:1.21.4.1-4-bullseye-amd64

# 替换系统 APT 源为阿里云
RUN  sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list \
    && sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list \
    && sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list \
    && sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list \
    && echo "alias ll='ls -Alh --color=auto'" >> ~/.bashrc \
    && echo "alias l='ls -Alh --color=auto'" >> ~/.bashrc \
    && echo "alias ls='ls --color=auto'" >> ~/.bashrc \
    && echo "set noswapfile" >> ~/.vimrc \
    && echo "imap jk <ESC>" >> ~/.vimrc \
    && echo "noremap H ^" >> ~/.vimrc \
    && echo "noremap L $" >> ~/.vimrc \
    && echo "map <f2> :w\|!nginx -s reload" >> ~/.vimrc \
    && echo "set ignorecase smartcase" >> ~/.vimrc \
    && echo "set nu" >> ~/.vimrc \
    && apt-get update -y \
    # 可执行选择安装程序和依赖
    && apt-get install -y vim iputils-ping net-tools telnet lsof htop less unzip curl wget \
    # 安装后的清理现场, 瘦身镜像
    && apt-get clean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

ENV TZ='<UTC>-8'

# HOW TO USE
# 1. 通过 docker build 镜像的命令
# docker build . -f openresty.DOCKERFILE -t registry.cn-shenzhen.aliyuncs.com/llll/openresty:1.21.4.1-4-bullseye-amd64

# 2. 通过 docker push 镜像的命令
# docker push registry.cn-shenzhen.aliyuncs.com/llll/openresty:1.21.4.1-4-bullseye-amd64
