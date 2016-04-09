FROM lfex/ubuntu:latest

ENV APP_DIR /opt/sample-app
ENV APP_REPO https://github.com/lfex/docker-lfe-yaws-sample-app.git

RUN apt-get update
RUN apt-get -f install -y
RUN apt-get install -y libpam0g-dev dh-autoreconf

COPY . $APP_DIR

RUN rm -rf $APP_DIR/_build/default/lib/yaws
RUN cd $APP_DIR && make

EXPOSE 5099

CMD ["/opt/sample-app/bin/run"]
