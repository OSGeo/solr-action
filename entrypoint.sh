#!/bin/sh
###############################################################################
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
###############################################################################

docker network create solr
# Download the latest JTS library (version 1.20.0)
JTS_DOWNLOAD_URL="https://repo1.maven.org/maven2/org/locationtech/jts/jts-core/1.20.0/jts-core-1.20.0.jar"
JTS_JAR_PATH="/tmp/jts-core.jar"
docker run --rm -v /tmp:/tmp curlimages/curl -L -o $JTS_JAR_PATH $JTS_DOWNLOAD_URL 

# Define the docker run command with volume mounting for the JTS library
docker_run="docker run"
docker_run="$docker_run --name solr1 --network solr -d -p $INPUT_HOST_PORT:$INPUT_CONTAINER_PORT"
docker_run="$docker_run -e SOLR_HEAP=1G -v $JTS_JAR_PATH:/opt/solr/server/solr-webapp/webapp/WEB-INF/lib/jts-core.jar"
docker_run="$docker_run solr:$INPUT_SOLR_VERSION solr-precreate test"

sh -c "$docker_run"
sleep 20
docker run --network solr --rm curlimages/curl -v --max-time 120 --retry 120 --retry-delay 1 --retry-connrefused --show-error --silent http://solr1:$INPUT_HOST_PORT
