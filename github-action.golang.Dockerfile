FROM golang:bullseye as builder

ADD . /tmp/ctx/

WORKDIR /tmp/ctx/

# ENV GO111MODULE=on
ENV TZ='<UTC>-8' 

# 拆成多段RUN, builder不需要合并RUN指令
RUN cd /tmp/ctx/

RUN ls -al

RUN go mod download

RUN go build -v -ldflags="-s -w -X 'main.Version=`date +'%Y-%m-%d %H:%M:%S'`'" -o app

RUN ls -al

RUN arch=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) \
&& wget https://github.com/chenset/mirror/releases/download/mirror/upx-3.96-${arch}_linux.tar -O /tmp/ctx/upx.tar

RUN tar --overwrite -xvf /tmp/ctx/upx.tar && ls -al && chmod +x /tmp/ctx/upx && /tmp/ctx/upx -5 app

## ---------------------------------------------------------------
## ---------------------------------------------------------------
## ---------------------------------------------------------------

FROM debian:stable

WORKDIR /root/

COPY --from=builder /tmp/ctx/app "/root/app"

#ENV TZ="Asia/Shanghai"
ENV TZ='<UTC>-8' 

RUN echo "alias ll='ls -Alh --color=auto'" >> ~/.bashrc \
   && echo "alias l='ls -Alh --color=auto'" >> ~/.bashrc \
   && echo "alias ls='ls --color=auto'" >> ~/.bashrc \
   && touch ~/github.actions.workflow.$(date +"%Y-%m-%d_%H.%M.%S").build \
   && touch ~/image.time.$(date +"%Y-%m-%d_%H.%M.%S").build \
   && export GITHUB_IMAGE_BUILD_TIME=`date +"%Y-%m-%d %H:%M:%S"` \
   && export IMAGE_BUILD_TIME=`date +"%Y-%m-%d %H:%M:%S"` \
   # vim 禁用 .swp
   && echo "set noswapfile" >> ~/.vimrc \
   && echo "imap jk <ESC>" >> ~/.vimrc \
   && echo "noremap H ^" >> ~/.vimrc \
   && echo "noremap L $" >> ~/.vimrc \
   && echo "set ignorecase smartcase" >> ~/.vimrc \
   # vim 启用行号
   && echo "set nu" >> ~/.vimrc \
   # 软连接
   && ln -s /root/app /usr/bin/app

CMD ["/root/app"]
