#!/bin/bash -p

set +o posix +m -o pipefail || exit 1
shopt -s lastpipe || exit 1

function die {
	printf '%s\n' "$1" >&2
	exit "${2-1}"
}

function main {
	local desc_file=${DESC_FILE-/var/db/repos/gentoo/profiles/profiles.desc} profiles profiles2

	# Extract new profiles
	awk '{ $0 = "" $2 } /^default\// && /\/musl(\/|$)/ || /(^|\/)prefix(\/|$)/' "${desc_file}" | \
			readarray -t profiles || die "Failed to enumerate profile names"
	[[ ${profiles+.} ]] || die "No musl-based profile names found"

	# Add old profiles
	readarray -tO "${#profiles[@]}" profiles < profiles.mask || die "Failed to add old profiles"

	# Remove profiles no longer included in profiles.desc as they'd cause pkgcheck to fail
	awk 'NR == FNR { a[$2] = 1; next } $0 in a' "${desc_file}" <(printf '%s\n' "${profiles[@]}") | \
			readarray -t profiles2 || die "Failed to exclude inexistent profiles"

	# Save
	printf '%s\n' "${profiles2[@]}" | sort -u > profiles.mask || \
		die "Failed to save profiles"
}

main "$@"
