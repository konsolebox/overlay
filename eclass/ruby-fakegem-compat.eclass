inherit use-ruby-mask ruby-utils-compat ruby-fakegem

if ! declare -pf ruby_fakegem_extensions_installed &>/dev/null; then
	ruby_fakegem_extensions_installed() {
		local extensions_dir
		extensions_dir=$(${RUBY} --disable=did_you_mean -e "puts File.join('extensions', Gem::Platform.local.to_s, Gem.extension_api_version)") || die
		extensions_dir=$(ruby_fakegem_gemsdir)/${extensions_dir}/${RUBY_FAKEGEM_NAME}-${RUBY_FAKEGEM_VERSION} || die
		mkdir -p "${ED}${extensions_dir}" || die
		touch "${ED}${extensions_dir}/gem.build_complete" || die
	}
fi
