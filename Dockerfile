FROM ubuntu:xenial


ENV DOWNLOAD_URL=https://dl.xonotic.org/xonotic-0.8.2.zip
ENV DOWNLOAD_HASH=a22f7230f486c5825b55cfdadd73399c9b0fae98c9e081dd8ac76eca08359ad5

RUN apt-get update && \
    apt-get upgrade -y &&\
    apt-get install -y unzip curl&&\
    apt-get clean &&\
    mkdir -p /app    
    
RUN curl $DOWNLOAD_URL  -o /tmp/xonotic.zip && \
    if [ "`sha256sum /tmp/xonotic.zip|cut -d' ' -f1`" != "$DOWNLOAD_HASH" ];\
    then\
    	echo "Download is corrupted"\
    	exit 1;\
    fi &&\
    unzip /tmp/xonotic.zip -d /app && \
    rm /tmp/xonotic.zip && \
    cp /app/Xonotic/server/server_linux.sh /app/Xonotic/server_linux.sh && \
    cp /app/Xonotic/server/server.cfg /app/Xonotic/server.cfg
    

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN groupadd --gid 1000 xonotic 
RUN useradd --uid 1000 -r --gid 1000 xonotic
RUN chown xonotic:xonotic -Rf /app/Xonotic
RUN mkdir -p /home/xonotic/.xonotic/data&&chown xonotic:xonotic -Rf /home/xonotic
USER xonotic

WORKDIR /app/Xonotic

ENTRYPOINT ["/app/Xonotic/xonotic-linux64-dedicated"]
