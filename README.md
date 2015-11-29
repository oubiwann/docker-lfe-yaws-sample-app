# sample-app

*An example LFE/YAWS Web App Running on Docker*

## Introduction

This repo is featured in
[this](http://blog.lfe.io/tutorials/2014/12/07/1837-running-lfe-in-docker/) as
well as
[this one](http://blog.lfe.io/tutorials/2015/11/28/2110-lfe-yaws-docker-update/).
The former goes into more detail on how to run LFE in docker, which the second
one is an update showing how to use the Docker image genereated from this repo
as quickly as possible.

## Use

To run the Docker image you need to have docker installed and running. Then
simply run the following:

```bash
$ docker run -p 5099:5099 -t oubiwann/lfe-yaws-sample-app:latest
```

You don't need the source code for that command; it will pull from Docker Hub.


## Building

If you should choose to build the Docker image yourself instead of getting it
from Docker Hub:

```bash
$ git clone git@github.com:oubiwann/docker-lfe-yaws-sample-app.git
$ cd docker-lfe-yaws-sample-app
$ make docker-build
$ make docker-run
```

For more details, you'll just need to read the blog posts linked above ;-)
