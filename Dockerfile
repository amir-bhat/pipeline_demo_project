FROM jenkins/jenkins:2.361.2-jdk11

USER root
RUN apt-get update
RUN apt-get -y install apt-transport-https ca-certificates curl gnupg2 lsb-release python3-distutils
RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
RUN python3 get-pip.py
RUN pip install -U ansible && pip cache purge
RUN mkdir -p /etc/apt/keyrings && curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update
RUN apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
RUN curl -SL "https://github.com/docker/compose/releases/download/v2.12.2/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose
RUN cd /tmp/ && curl -O "https://downloads.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz" && tar -xvzf apache-maven-3.8.6-bin.tar.gz && mv apache-maven-3.8.6 /opt/maven && rm -f /tmp/apache-maven-3.8.6-bin.tar.gz
ENV M2_HOME="/opt/maven"
ENV PATH="${M2_HOME}/bin:${PATH}"
RUN cd /tmp/ && curl -O "https://downloads.gradle-dn.com/distributions/gradle-7.4.2-bin.zip" && unzip gradle-7.4.2-bin.zip && mv gradle-7.4.2 /opt/gradle && rm -r /tmp/gradle-7.4.2-bin.zip
ENV PATH="/opt/gradle/bin:${PATH}"
RUN usermod -aG docker jenkins
RUN apt-get clean
USER jenkins
