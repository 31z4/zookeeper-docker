This image is proposed to [Docker official images](https://hub.docker.com/explore/). Please send [this PR](https://github.com/docker-library/official-images/pull/1765) some love to make this happen!

# Supported tags and respective `Dockerfile` links

* `3.3.6` [(3.3.6/Dockerfile)](https://github.com/31z4/zookeeper-docker/blob/master/3.3.6/Dockerfile)
* `3.4.8`, `latest` [(3.4.8/Dockerfile)](https://github.com/31z4/zookeeper-docker/blob/master/3.4.8/Dockerfile)

[![](https://badge.imagelayers.io/31z4/storm:latest.svg)](https://imagelayers.io/?images=31z4%2Fzookeeper:3.4.8,31z4%2Fzookeeper:3.3.6)

# What is Apache Zookeeper?

Apache ZooKeeper is a software project of the Apache Software Foundation, providing an open source distributed configuration service, synchronization service, and naming registry for large distributed systems. ZooKeeper was a sub-project of Hadoop but is now a top-level project in its own right.

> [wikipedia.org/wiki/Apache_ZooKeeper](https://en.wikipedia.org/wiki/Apache_ZooKeeper)

# How to use this image

## Start a Zookeeper server instance

	$ docker run --name some-zookeeper -d 31z4/zookeeper

This image includes `EXPOSE 2181` (the zookeeper port), so standard container linking will make it automatically available to the linked containers.

## Connect to Zookeeper from an application in another Docker container

	$ docker run --name some-app --link some-zookeeper:zookeeper -d application-that-uses-zookeeper

## Connect to Zookeeper from the Zookeeper command line client

	$ docker run -it --rm --link some-zookeeper:zookeeper 31z4/zookeeper zkCli.sh -server zookeeper

## Configuration

This images uses [sample configuration](https://github.com/apache/zookeeper/blob/release-3.4.8/conf/zoo_sample.cfg) of the Apache Zookeeper which is located in the `/conf` directory. The simplest way to change it is to mount your config file as a volume

	$ docker run --name some-zookeeper -d -v $(pwd)/zoo.cfg:/conf/zoo.cfg 31z4/zookeeper

# License

View [license information](https://github.com/apache/zookeeper/blob/release-3.4.8/LICENSE.txt) for the software contained in this image.
