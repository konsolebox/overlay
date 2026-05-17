#!/bin/bash -p

set +o posix +m -o pipefail || exit 1
shopt -s lastpipe || exit 1

function die {
	printf '%s\n' "$1" >&2
	exit "${2-1}"
}

function main {
	local desc_file=${DESC_FILE-/var/db/repos/gentoo/profiles/profiles.desc} helpers_dir profiles \
			profiles2

	helpers_dir=$(realpath -m -- "${BASH_SOURCE}/../..") || \
		die "Unable to locate helpers directory."

	# Extract new profiles
	awk '/^\s*(#|$)/ { next } { $0 = "" $2 }
			/^default\// && /\/musl(\/|$)/ || /(^|\/)prefix(\/|$)/ || $3 == "exp"' "${desc_file}" | \
			readarray -t profiles || die "Failed to enumerate profile names"
	[[ ${profiles+.} ]] || die "No musl-based profile names found"

	# Add old profiles
	readarray -tO "${#profiles[@]}" profiles < "${helpers_dir}/profiles.mask" || \
		die "Failed to add old profiles"

	# Remove profiles no longer included in profiles.desc as they'd cause pkgcheck to fail
	awk '/^\s*(#|$)/ { next } NR == FNR { a[$2] = 1; next } $0 in a' "${desc_file}" \
			<(printf '%s\n' "${profiles[@]}") | \
			readarray -t profiles2 || die "Failed to exclude inexistent profiles"

	# Save
	printf '%s\n' "${profiles2[@]}" | sort -u > "${helpers_dir}/profiles.mask" || \
		die "Failed to save profiles"
}

main "$@"
