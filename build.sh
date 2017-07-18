#!/bin/bash

echo -e "Building H2O docker image..."

function build_img() {
  local prefix=$1
  local imgname=$2
  local img="${prefix}/${imgname}"

  echo -e "Building docker image ${imgname}..."
  docker build -t $img .
}

IMGPREFIX=bwv988

build_img $IMGPREFIX h2oai
