FROM apache/hive:3.1.3

USER root

RUN apt-get update -y
RUN apt-get -y install wget

# We will work with a MySql DB as a external metadata storage, so we need to add the MySql jars to the image
RUN wget "https://downloads.mysql.com/archives/get/p/3/file/mysql-connector-j-8.1.0.tar.gz"
RUN tar -xvf "mysql-connector-j-8.1.0.tar.gz"
RUN mv mysql-connector-j-8.1.0/mysql-connector-j-8.1.0.jar lib/
RUN rm "mysql-connector-j-8.1.0.tar.gz"
RUN rm -rf "mysql-connector-j-8.1.0"

# Add the AWS libraries to be able to connect the metastore with S3
RUN wget "https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-s3/1.12.99/aws-java-sdk-s3-1.12.99.jar"
RUN mv aws-java-sdk-s3-1.12.99.jar /opt/hadoop/share/hadoop/tools/lib/
RUN wget "https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-core/1.12.99/aws-java-sdk-core-1.12.99.jar"
RUN mv aws-java-sdk-core-1.12.99.jar /opt/hadoop/share/hadoop/tools/lib/

# Add file with the required environment variables, in this case the variables with info to connect to S3
COPY hive-env.sh /opt/hive/conf/hive-env.sh

USER hive
