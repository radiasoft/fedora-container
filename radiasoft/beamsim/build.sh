#!/bin/bash
build_image_base=radiasoft/python2

run_as_exec_user() {
    cd
    pyenv activate
    cd "$build_guest_conf"
    . ./codes.sh
}