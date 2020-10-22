# Cassandra 3.11.5 Dockerfile
#
# https://github.com/oscerd/docker-cassandra

# Pull base image.
FROM oscerd/java:oraclejava8
MAINTAINER Andrea Cosentino <ancosen1985@yahoo.com>

# install python2.7 for cqlsh
RUN apt-get update && \
    apt-get install -y python2.7 && \
    apt-get clean

# Download and extract Cassandra
RUN mkdir /opt/cassandra
RUN cd /tmp/
RUN wget -O - http://archive.apache.org/dist/cassandra/3.11.5/apache-cassandra-3.11.5-bin.tar.gz | tar xzf - --strip-components=1 -C "/opt/cassandra"

# put cqlsh on PATH
RUN ln -s /opt/cassandra/bin/cqlsh /usr/local/bin/cqlsh

COPY . /src

# Setting up environment variables
ENV MAX_HEAP_SIZE 4G
ENV HEAP_NEWSIZE 800M

# Copy over daemons
RUN cp /src/cassandra.yaml /opt/cassandra/conf/
RUN mkdir -p /etc/service/cassandra
RUN cp /src/start-cassandra /etc/service/cassandra/run

# Expose ports
EXPOSE 7000 7001 7199 9160 9042

RUN apt-get clean 
RUN rm -rf /var/lib/apt/lists/* 
RUN rm -rf /tmp/* 
RUN rm -rf /var/tmp/*

CMD ["/sbin/my_init"]
