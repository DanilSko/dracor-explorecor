# D7.3 Report on Versioning of APIs and Copora
# Docker in Docker (dind) with pre-configured jupyter lab
FROM docker:24.0.6-dind-alpine3.18

MAINTAINER Ingo Börner (ingo.boerner@uni-potsdam.de)

USER root

# Install required packages
RUN apk add --update gcc musl-dev linux-headers python3-dev py3-pip py3-numpy py3-pandas py3-nltk libffi-dev g++ jpeg-dev zlib-dev libjpeg make curl git bash
RUN pip install --upgrade pip

WORKDIR /home/dracor

# Install stabledracor
RUN git clone -b api_v1 https://github.com/ingoboerner/stable-dracor.git

WORKDIR /home/dracor/stable-dracor
RUN pip install .

WORKDIR /home/dracor

# Install matplotlib
RUN pip install matplotlib

# Install Jupyter lab
RUN pip install jupyterlab==4.0.12

# Jupyter book
RUN pip install jupyter-book

COPY entrypoint.sh /home/dracor/entrypoint.sh
RUN chmod +x /home/dracor/entrypoint.sh

# ports:  8889 = Jupyter Lab
# need to open additional ports: 3030 = fuseki, 8080 = eXist Dashboard, 8088 = DraCor API, 8787 = rstudio

EXPOSE 3030 8080 8088 8889 8787

ENTRYPOINT ["./entrypoint.sh"]

CMD []