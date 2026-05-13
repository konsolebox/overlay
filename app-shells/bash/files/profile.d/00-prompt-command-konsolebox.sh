# This unit serves to initialise PROMPT_COMMAND as early as possible in cases
# where bash has been launched as a login shell. Though not an especially
# common practice, some profile.d drop-ins need to be able to extend its value.

# Setting PROMPT_COMMAND to an array isn't needed for scripts to add values to it
# but unfortunately some scripts like vte-2.91.sh checks it first if it's an
# array before usingn it as one.
#
# https://github.com/GNOME/vte/blob/f2f37d8678798d95054b03dc16a099f16e9b12ab/src/vte.sh.in#L82

if [ -n "${BASH_VERSION}" ]; then
	eval '[[ BASH_VERSINFO -ge 6 || BASH_VERSINFO -eq 5 && BASH_VERSINFO[1] -ge 1 ]] && PROMPT_COMMAND=()'
fi
