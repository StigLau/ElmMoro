FROM openjdk:13-alpine

RUN apk add curl
RUN curl -L -o elm.gz https://github.com/elm/compiler/releases/download/0.19.1/binary-for-linux-64-bit.gz
RUN curl -L -o /root/kompost-0.4.jar https://kompost.s3.amazonaws.com/maven/no/lau/kompost/kompost/0.4/kompost-0.4.jar

RUN gunzip elm.gz && chmod +x elm && mv elm /usr/local/bin/

#aws credentials have to be copied locally
COPY credentials /root/.aws/

ADD kompostedit kompostedit
WORKDIR kompostedit
RUN chmod +x start-frontend.sh && mv /kompostedit/start-frontend.sh /usr/local/bin/

EXPOSE 8001

CMD ["start-frontend.sh"]


#docker run -it --rm alpine ash