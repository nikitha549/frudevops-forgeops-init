#!/usr/bin/env bash
[[ "${FR_DEBUG}" == true ]] && set -x
if ! "${HOME}/.local/bin/bootstrap-project.sh" init-workspace;
then
    echo "failed to bootstrap project";
    exit 1
fi
exec "${@}"
