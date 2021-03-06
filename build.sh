#!/bin/bash
# Copyright 2019 Decipher Technology Studios
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

BUILD_DIRECTORY="$(date +%s)"
KAFKA_MIRROR="${KAFKA_MIRROR:-http://www-us.apache.org/dist/kafka}"
KAFKA_VERSION="${KAFKA_VERSION:-2.1.0}"
SCALA_VERSION="${SCALA_VERSION:-2.11}"

mkdir -p "${BUILD_DIRECTORY}"

pushd "${BUILD_DIRECTORY}"

mkdir -p kafka
pushd kafka

wget "${KAFKA_MIRROR}/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz"
tar -xvf "kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz"

popd

popd

KF_MAJOR="$(echo ${KAFKA_VERSION} | awk -F '[\.\-]' '{print $1}')"
KF_MINOR="$(echo ${KAFKA_VERSION} | awk -F '[\.\-]' '{print $2}')"
KF_PATCH="$(echo ${KAFKA_VERSION} | awk -F '[\.\-]' '{print $3}')"

SC_MAJOR="$(echo ${SCALA_VERSION} | awk -F '[\.\-]' '{print $1}')"
SC_MINOR="$(echo ${SCALA_VERSION} | awk -F '[\.\-]' '{print $2}')"


docker build . \
    --build-arg "kafka_version=${KAFKA_VERSION}" \
    --build-arg "kafka_directory=./${BUILD_DIRECTORY}/kafka/kafka_${SCALA_VERSION}-${KAFKA_VERSION}" \
    --build-arg "scala_version=${SCALA_VERSION}" \
    -t deciphernow/kafka:${KF_MAJOR}-${SC_MAJOR} \
    -t deciphernow/kafka:${KF_MAJOR}.${KF_MINOR}-${SC_MAJOR}.${SC_MINOR} \
    -t deciphernow/kafka:${KF_MAJOR}.${KF_MINOR}.${KF_PATCH}-${SC_MAJOR}.${SC_MINOR}

rm -rf "${BUILD_DIRECTORY}"

