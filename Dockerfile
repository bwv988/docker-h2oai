# From official Docker file.
# Changed to Debian Jessie-based image.

FROM debian:jessie

# FIXME: Use webupd8team JAVA installer.

ENV JAVA_MAJOR=8
ENV JAVA_MINOR=131
ENV JAVA_BUILD=b11
ENV JAVA_LOC_HASH=d54c1d3a095b4ff2b6607d096fa80163
ENV JAVA_VERSION=${JAVA_MAJOR}u${JAVA_MINOR}
ENV JAVA_HOME=/opt/jdk1.8.0_$JAVA_MINOR
ENV JDK_DL_URL=http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION}-$JAVA_BUILD/${JAVA_LOC_HASH}/jdk-$JAVA_VERSION-linux-x64.tar.gz
ENV PATH=$JAVA_HOME/bin:/opt/bin:/$PATH

COPY files/entrypoint.sh /opt/bin/

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    wget \
    unzip \
    curl \
    python-pip \
    python-sklearn \
    python-pandas \
    python-numpy \
    python-matplotlib \
    software-properties-common \
    python-software-properties && \

# Install Java 8.
    curl --retry 3 -k -L -C - -b "oraclelicense=accept-securebackup-cookie" -O "$JDK_DL_URL" && \
    tar xvf jdk-$JAVA_VERSION-linux-x64.tar.gz -C /opt/  && \
    ln -s $JAVA_HOME /opt/java && \
    rm jdk-$JAVA_VERSION-linux-x64.tar.gz && \
    apt-get clean && \

# Fetch h2o latest_stable.
    wget http://h2o-release.s3.amazonaws.com/h2o/latest_stable -O latest && \
    wget --no-check-certificate -i latest -O /opt/h2o.zip && \
    unzip -d /opt /opt/h2o.zip && \
    rm /opt/h2o.zip && \
    cd /opt && \
    cd `find . -name 'h2o.jar' | sed 's/.\///;s/\/h2o.jar//g'` && \
    cp h2o.jar /opt && \
    /usr/bin/pip install `find . -name "*.whl"` && \
    chmod +x /opt/bin/entrypoint.sh && \

# Get content.
    mkdir -p /opt/data && \
    mkdir -p /workdir/logs && \
    mkdir -p /workdir/data && \
    cd /workdir/data && \
    wget http://s3.amazonaws.com/h2o-training/mnist/train.csv.gz && \
    gunzip train.csv.gz && \
    wget https://raw.githubusercontent.com/laurendiperna/Churn_Scripts/master/Extraction_Script.py  && \
    wget https://raw.githubusercontent.com/laurendiperna/Churn_Scripts/master/Transformation_Script.py && \
    wget https://raw.githubusercontent.com/laurendiperna/Churn_Scripts/master/Modeling_Script.py

# Define the working directory.
WORKDIR /workdir

EXPOSE 54321
EXPOSE 54322

ENTRYPOINT ["/opt/bin/entrypoint.sh"]
CMD ["start"]
