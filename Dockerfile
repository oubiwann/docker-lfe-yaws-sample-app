FROM lfex/debian

ENV APP_DIR /opt/sample-app
ENV APP_REPO https://github.com/oubiwann/docker-lfe-yaws-sample-app.git
ENV DEPS_DIR $APP_DIR/deps
ENV YAWS_DIR $DEPS_DIR/yaws
ENV YAWS_APP_ID sampleapp
ENV LFE_DEPS $DEPS_DIR/lutil:$DEPS_DIR/exemplar:$DEPS_DIR/lfest
ENV DEPS $YAWS_DIR:$LFE_DEPS:$DEPS_DIR/ibrowse
ENV ERL_LIBS $ERL_LIBS:$LFE_HOME:$DEPS

RUN apt-get -f install -y
RUN apt-get install -y libpam0g-dev

RUN git clone $APP_REPO $APP_DIR && \
        cd $APP_DIR && \
        ln -s $LFE_HOME $DEPS_DIR/lfe && \
        rebar compile

EXPOSE 5099

CMD sh -c "/opt/sample-app/bin/daemon;while true; do sleep 10; done"
