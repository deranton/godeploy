FROM alpine:3.4

RUN apk -U add ca-certificates

EXPOSE 8080

ADD news /bin/godeploy

# ADD config.yml /etc/godeploy/config.yml

CMD ["godeploy", "-config", "/etc/godeploy/config.yml"]
