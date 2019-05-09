FROM ubuntu:18.04 as builder

RUN apt-get update \
  && apt-get -y install curl

ENV JAVA_HOME=/jdk
ENV MAVEN_HOME=/maven
ENV JDK_URL=https://download.java.net/java/GA/jdk12.0.1/69cfe15208a647278a19ef0990eea691/12/GPL/openjdk-12.0.1_linux-x64_bin.tar.gz
ENV MAVEN_URL=https://www-us.apache.org/dist/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz

RUN mkdir -p $JAVA_HOME \
    && curl -SL $JDK_URL \
    | tar -zxC $JAVA_HOME --strip 1

RUN mkdir -p $MAVEN_HOME \
    && curl -SL $MAVEN_URL \
    | tar -zxC $MAVEN_HOME --strip 1


ENV PATH=$PATH:$JAVA_HOME/bin:$MAVEN_HOME/bin

RUN rm -rf /var/lib/apt/lists/*

ENV BUILD_HOME=/build
WORKDIR $BUILD_HOME

RUN mkdir -p $BUILD_HOME
COPY pom.xml $BUILD_HOME/
RUN mvn dependency:go-offline

COPY src/ $BUILD_HOME/src
RUN mvn package

RUN jlink \
  --module-path $JAVA_JOME/jmods \
  --verbose \
  --add-modules java.base,java.logging,java.sql,java.naming,java.desktop,java.xml,java.management,java.security.jgss,java.instrument \
  --output jre

FROM ubuntu:18.04
ENV JAVA_HOME=/jre
ENV PATH=$PATH:$JAVA_HOME/bin
COPY --from=builder /build/target/*.jar /app.jar
COPY --from=builder /build/jre $JAVA_HOME
RUN java -Xshare:dump;

CMD ["java", "-jar","/app.jar"]
