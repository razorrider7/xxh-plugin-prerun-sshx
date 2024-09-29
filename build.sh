#!/usr/bin/env bash

main() {
  #############
	need_cmd curl
	need_cmd chmod
  #############
	build
}

build() {

  CDIR="$(cd "$(dirname "$0")" && pwd)"
  build_dir=$CDIR/build

  while getopts A:K:q option
  do
    case "${option}"
    in
      q) QUIET=1;;
      A) ARCH=${OPTARG};;
      K) KERNEL=${OPTARG};;
    esac
  done

  rm -rf $build_dir
  mkdir -p $build_dir

  cd $CDIR
  cp *prerun.sh *pluginrc.* $build_dir/

  portable_url='https://sshx.s3.amazonaws.com/sshx-x86_64-unknown-linux-musl.tar.gz'
  tarname=`basename $portable_url`

  cd $build_dir

  if [ -x "$(command -v curl)" ]; then
    curl $arg_s -L $portable_url -o $tarname
  else
    echo Install curl
  fi

  tar -xzf $tarname
  rm $tarname
}

cmd_chk() {
  >&2 echo Check "$1"
	command -v "$1" >/dev/null 2>&1
}

need_cmd() {
  if ! cmd_chk "$1"; then
    error "need $1 (command not found)"
    exit 1
  fi
}

main "$@" || exit 1
