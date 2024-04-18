#!/bin/bash -p

set +o posix +m -o pipefail || exit 1
shopt -s lastpipe || exit 1

function die {
	printf '%s\n' "$1" >&2
	exit "${2-1}"
}

function main {
	local desc_file=/var/db/repos/gentoo/profiles/profiles.desc profiles

	# Extract new profiles
	awk '{ $0 = "" $2 } /^default\// && /\/musl(\/|$)/' "${desc_file}" | \
			readarray -t profiles || die "Failed to enumerate profile names"
	[[ ${profiles+.} ]] || die "No musl-based profile names found"

	# Add old profiles
	readarray -tO "${#profiles[@]}" profiles < profiles.mask || die "Failed to add old profiles"

	# Save
	printf '%s\n' "${profiles[@]}" | sort -u > profiles.mask || die "Failed to save profiles"
}

main "$@"
