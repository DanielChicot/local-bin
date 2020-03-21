#!/bin/bash

source ~/bin/environment.sh

_ERROR_STATEMENT_NOT_ON_GDRIVE=2
_ERROR_GDRIVE_NOT_INSTALLED=3

main() {

    if ! which gdrive >/dev/null; then
        warn could not find gdrive executable.
        return $_ERROR_GDRIVE_NOT_INSTALLED
    fi

    local statement=${1:-StarlingStatement_$(date '+%Y-%m').csv}
    info statement: \'$statement\'.
    declare -a stats=($(gdrive list --query "name contains '$statement'" --no-header))
    local id=${stats[0]}
    info id: \'$id\'.

    if [[ -z "$id" ]]; then
        warn \'$statement\': not on found on google drive.
        return $_ERROR_STATEMENT_NOT_ON_GDRIVE
    fi

    if gdrive download --force $id >&2; then
        statement.pl $statement
    fi
}

main $@
