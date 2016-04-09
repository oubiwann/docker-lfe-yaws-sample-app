# LFE+YAWS: Docker

*A Sample LFE+YAWS Web Application Running on Docker*


#### Contents

* [Introduction](#introduction-)
* [Use](#use-)
* [Building](#building-)


## Introduction [&#x219F;](#contents)

This repo is featured in following LFE blog posts:

* [Running LFE in Docker](http://blog.lfe.io/tutorials/2014/12/07/1837-running-lfe-in-docker/)
* [LFE+YAWS Docker Update](http://blog.lfe.io/tutorials/2015/11/28/2110-lfe-yaws-docker-update/)

The former goes into more detail on how to run LFE in docker, which the second
one is an update showing how to use the Docker image genereated from this repo
as quickly as possible.

The code for the actual LFE+YAWS sample app resides in the
[lfeyawsdemo](https://github.com/lfex/lfeyawsdemo) repository. The
docker-lfe-yaws-sample-app project is a ``Dockerfile``, a ``make`` file, and
some convenience scripts. The primary purpose of this repo is to maintain the
Docker image that gets pushed to
[Docker Hub](https://hub.docker.com/r/lfex/lfe-yaws-sample-app/).


## Use [&#x219F;](#contents)

To run the Docker image you need to have docker installed and running. Then
simply run the following:

```bash
$ docker run -p 5099:5099 -t lfex/lfe-yaws-sample-app
```

You don't need the source code for that command; it will pull from Docker Hub.


## Building [&#x219F;](#contents)

If you should choose to build the Docker image yourself instead of getting it
from Docker Hub:

```bash
$ git clone git@github.com:lfex/docker-lfe-yaws-sample-app.git
$ cd docker-lfe-yaws-sample-app
$ make docker-build
$ make docker-run
```

For more details, you'll just need to read the blog posts linked above ;-)
