#!/usr/bin/env bash

# Copyright 2016 The Kubernetes Authors.
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

# This script downloads and installs the Kubernetes client and server
# (and optionally test) binaries,
# It is intended to be called from an extracted Kubernetes release tarball.
#
# We automatically choose the correct client binaries to download.
#
# Options:
#  Set KUBERNETES_SERVER_ARCH to choose the server (Kubernetes cluster)
#  architecture to download:
#    * amd64 [default]
#    * arm
#    * arm64
#    * ppc64le
#    * s390x
#
#  Set KUBERNETES_SKIP_CONFIRM to skip the installation confirmation prompt.
#  Set KUBERNETES_RELEASE_URL to choose where to download binaries from.
#    (Defaults to https://storage.googleapis.com/kubernetes-release/release).
#  Set KUBERNETES_DOWNLOAD_TESTS to additionally download and extract the test
#    binaries tarball.

#KUBE_VERSION
#k8stype

set -o errexit
set -o nounset
set -o pipefail

#KUBE_ROOT=/opt
KUBE_ROOT=$HOME
KUBERNETES_RELEASE_URL="${KUBERNETES_RELEASE_URL:-https://dl.k8s.io}"


if [ $# -ne 2 ]
then
	echo "please provide version and k8stype"
	echo "version -- v1.x.x"
	echo "k8stype - CLIENT OR NODE"
	exit 1
fi

KUBE_VERSION=$1
k8stype=$2

function detect_kube_release() {
  if [[ -n "${KUBE_VERSION:-}" ]]; then
    return 0  # Allow caller to explicitly set version
  fi
}

function detect_client_info() {
  local kernel=$(uname -s)
  case "${kernel}" in
    Darwin)
      CLIENT_PLATFORM="darwin"
      ;;
    Linux)
      CLIENT_PLATFORM="linux"
      ;;
    *)
      echo "Unknown, unsupported platform: ${kernel}." >&2
      echo "Supported platforms: Linux, Darwin." >&2
      echo "Bailing out." >&2
      exit 2
  esac

  # TODO: migrate the kube::util::host_platform function out of hack/lib and
  # use it here.
  local machine=$(uname -m)
  case "${machine}" in
    x86_64*|i?86_64*|amd64*)
      CLIENT_ARCH="amd64"
      ;;
    aarch64*|arm64*)
      CLIENT_ARCH="arm64"
      ;;
    arm*)
      CLIENT_ARCH="arm"
      ;;
    i?86*)
      CLIENT_ARCH="386"
      ;;
    s390x*)
      CLIENT_ARCH="s390x"
      ;;	  
    *)
      echo "Unknown, unsupported architecture (${machine})." >&2
      echo "Supported architectures x86_64, i686, arm, arm64, s390x." >&2
      echo "Bailing out." >&2
      exit 3
      ;;
  esac
}

function md5sum_file() {
  if which md5 >/dev/null 2>&1; then
    md5 -q "$1"
  else
    md5sum "$1" | awk '{ print $1 }'
  fi
}

function sha1sum_file() {
  if which sha1sum >/dev/null 2>&1; then
    sha1sum "$1" | awk '{ print $1 }'
  else
    shasum -a1 "$1" | awk '{ print $1 }'
  fi
}

function download_tarball() {
  local -r download_path="$1"
  local -r file="$2"
  url="${DOWNLOAD_URL_PREFIX}/${file}"
  mkdir -p "${download_path}"
  if [[ $(which curl) ]]; then
    curl -fL --retry 3 --keepalive-time 2 "${url}" -o "${download_path}/${file}"
  elif [[ $(which wget) ]]; then
    wget "${url}" -O "${download_path}/${file}"
  else
    echo "Couldn't find curl or wget.  Bailing out." >&2
    exit 4
  fi
  echo
  local md5sum=$(md5sum_file "${download_path}/${file}")
  echo "md5sum(${file})=${md5sum}"
  local sha1sum=$(sha1sum_file "${download_path}/${file}")
  echo "sha1sum(${file})=${sha1sum}"
  echo
  # TODO: add actual verification
}

function extract_arch_tarball() {
  local -r tarfile="$1"
  local -r platform="$2"
  local -r arch="$3"

  platforms_dir="${KUBE_ROOT}/${KUBE_VERSION}/${platform}/${arch}"
  echo "Extracting ${tarfile} into ${platforms_dir}"
  mkdir -p "${platforms_dir}"
  # Tarball looks like kubernetes/{client,server}/bin/BINARY"
  tar -xzf "${tarfile}" --strip-components 3 -C "${platforms_dir}"
}

detect_kube_release
DOWNLOAD_URL_PREFIX="${KUBERNETES_RELEASE_URL}/${KUBE_VERSION}"

SERVER_PLATFORM="linux"
SERVER_ARCH="${KUBERNETES_SERVER_ARCH:-amd64}"
SERVER_TAR="kubernetes-node-${SERVER_PLATFORM}-${SERVER_ARCH}.tar.gz"

detect_client_info
CLIENT_TAR="kubernetes-client-${CLIENT_PLATFORM}-${CLIENT_ARCH}.tar.gz"

echo "Kubernetes release: ${KUBE_VERSION}"
echo "Server: ${SERVER_PLATFORM}/${SERVER_ARCH}  (to override, set KUBERNETES_SERVER_ARCH)"
echo "Client: ${CLIENT_PLATFORM}/${CLIENT_ARCH}  (autodetected)"
echo

# TODO: remove this check and default to true when we stop shipping server
# tarballs in kubernetes.tar.gz
#download_tarball "${KUBE_ROOT}/${KUBE_VERSION}" "${SERVER_TAR}"
case ${k8stype} in
"CLIENT")
	download_tarball "${KUBE_ROOT}/${KUBE_VERSION}" "${CLIENT_TAR}"
	extract_arch_tarball "${KUBE_ROOT}/${KUBE_VERSION}/${CLIENT_TAR}" "${CLIENT_PLATFORM}" "${CLIENT_ARCH}"
	rsync -az $platforms_dir/kubectl /usr/bin
	;;
"NODE")
	download_tarball "${KUBE_ROOT}/${KUBE_VERSION}" "${SERVER_TAR}"
	extract_arch_tarball "${KUBE_ROOT}/${KUBE_VERSION}/${SERVER_TAR}" "${SERVER_PLATFORM}" "${CLIENT_ARCH}"
	rsync -az $platforms_dir/kubelet /usr/bin
	;;
"BOTH")
        download_tarball "${KUBE_ROOT}/${KUBE_VERSION}" "${CLIENT_TAR}"
        extract_arch_tarball "${KUBE_ROOT}/${KUBE_VERSION}/${CLIENT_TAR}" "${CLIENT_PLATFORM}" "${CLIENT_ARCH}"
	rsync -az $platforms_dir/kubectl /usr/bin
        download_tarball "${KUBE_ROOT}/${KUBE_VERSION}" "${SERVER_TAR}"
        extract_arch_tarball "${KUBE_ROOT}/${KUBE_VERSION}/${SERVER_TAR}" "${SERVER_PLATFORM}" "${CLIENT_ARCH}"
        rsync -az $platforms_dir/kubelet /usr/bin
	;;
esac
