#!/bin/bash

source ~/bin/environment.sh

_ERROR_NOT_ON_DRIVE=2

main() {
    statement=${1:-StarlingStatement_$(date '+%Y-%m-%d').csv}
    info statement: \'$statement\'.
    declare -a stats=($(gdrive list --query "name contains '$statement'" --no-header))
    local id=${stats[0]}
    info id: \'$id\'.
    if [[ -n "$id" ]]; then
        if gdrive download --force $id; then
            statement.pl $statement
        fi
    else
        warn \'$statement\': not on found on google drive.
        return $_ERROR_NOT_ON_DRIVE
    fi
}

main $@
