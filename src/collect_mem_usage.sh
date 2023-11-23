#!/bin/bash

# strict mode
set -euo pipefail

usage() {
	echo "Usage: $0 [-d <data directory>] [-s <sample rate in secs>]"
	exit 1
}

collect_data() {
	local data_dir=$1
	local timestamp=$2

	while read pid rss; do
		echo "${timestamp} ${rss}" >>${data_dir}/${pid}.dat
	done <<<"$(ps -e -o pid,rss | grep -v PID)"
}

main() {
	local data_dir="/tmp/mem_usage"
	local sample_rate=300 # 5 minutes

	while getopts ":d:s:" ARG; do
		case "${ARG}" in
		d) data_dir=${OPTARG} ;;
		s) sample_rate=${OPTARG} ;;
		*) usage ;;
		esac
	done

	mkdir -p ${data_dir}

	echo "Collecting data every ${sample_rate} seconds"
	echo "Data directory: ${data_dir}"

	while true; do
		local timestamp=$(date +"%Y%m%d_%H%M%S")
		echo "${timestamp}: Sampling memory usage"
		collect_data ${data_dir} ${timestamp}
		sleep ${sample_rate}
	done
}

main "$@"
