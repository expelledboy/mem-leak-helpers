#!/bin/bash

# strict mode
set -euo pipefail

usage() {
	echo "Usage: $0 [-d <data directory>]"
	exit 1
}

main() {
	local data_dir="/tmp/mem_usage"

	while getopts ":d:r:" ARG; do
		case "${ARG}" in
		d) data_dir=${OPTARG} ;;
		*) usage ;;
		esac
	done

	gnuplot -c src/graph_dats.gnuplot "$(find ${data_dir} -name '*.dat')"
}

main "$@"
