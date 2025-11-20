FROM bde2020/hadoop-base:2.0.0-hadoop3.2.1-java

RUN echo "deb http://archive.debian.org/debian stretch main" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security stretch/updates main" >> /etc/apt/sources.list && \
    apt-get -o Acquire::Check-Valid-Until=false update

RUN apt-get install -y wget python3

RUN wget https://archive.apache.org/dist/pig/pig-0.17.0/pig-0.17.0.tar.gz \
    && tar -xzf pig-0.17.0.tar.gz -C /usr/local/ \
    && mv /usr/local/pig-0.17.0 /usr/local/pig \
    && rm pig-0.17.0.tar.gz

ENV PATH=$PATH:/usr/local/pig/bin
ENV PIG_HOME=/usr/local/pig
ENV PIG_CLASSPATH=/etc/hadoop/conf/

WORKDIR /workspace/batch_analysis/pig

CMD ["/bin/bash"]