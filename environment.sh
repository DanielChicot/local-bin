#!/bin/bash

warn() {
    _log WARN $@
}

info() {
    _log INFO $@
}

debug() {
    _log DEBUG $@
}

_log() {
    local level=${1:?Usage: $FUNCNAME level}
    shift
    declare -a calling_context=($(caller 1))
    local line=${calling_context[0]}
    local procedure=${calling_context[1]}
    local script=$(basename ${calling_context[2]})
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    stderr [$level] [$timestamp] [$script:$procedure:$line] $@
}

stderr() {
    echo $@ >&2
}
