# frozen_string_literal: true

module Gem
  module OperatingSystemDefaults
    def user_dir
      gentoo_user_dir
    end

    def default_dir
      gentoo_user_dir
    end

    def default_bindir
      gentoo_user_bindir
    end

    def default_path
      path = []
      path << gentoo_user_dir unless gentoo_local_dir == gentoo_user_dir
      path << gentoo_local_dir
      path << gentoo_dir

      if vendor_dir && File.directory?(vendor_dir)
        path << vendor_dir # Last as it should be.
        path << gentoo_dir # Workaround so fakegem wrappers get this intead of vendor_dir
      end

      path
    end

    def operating_system_defaults
      { "custom_shebang" => File.join(_rbconfig("bindir"), "ruby") }
    end

    def default_specifications_dir
      orig_default_specifications_dir
    end

  private
    def _rbconfig(key)
      RbConfig::CONFIG[key] or raise "RbConfig::CONFIG[#{key.inspect}] unset."
    end

    def gentoo_dir
      @gentoo_dir ||= _rbconfig("sitelibdir").gsub("site_ruby", "gems")
    end

    def gentoo_local_dir
      @gentoo_local_dir ||= begin
        prefix = _rbconfig("exec_prefix")

        if gentoo_dir[0, prefix.size] == prefix
          File.join(prefix, "local", gentoo_dir[prefix.size..-1])
        else
          orig_user_dir_with_suffix
        end
      end
    end

    def gentoo_user_dir
      @gentoo_user_dir ||= Process.euid.zero? ? gentoo_local_dir : orig_user_dir_with_suffix
    end

    def gentoo_user_bindir
      @gentoo_user_bindir ||= begin
        if Process.euid.zero? && gentoo_local_dir != orig_user_dir_with_suffix
          File.join(_rbconfig("exec_prefix"), "local", "bin")
        else
          File.join(user_home, "bin")
        end
      end
    end

    def orig_user_dir_with_suffix
      @orig_user_dir_with_suffix ||= method(:user_dir).super_method.call + "-system"
    end

    def orig_default_specifications_dir
      @orig_default_specifications_dir ||= File.join(_rbconfig("rubylibprefix"), "gems",
          _rbconfig("ruby_version"), "specifications", "default")
    end
  end

  self.singleton_class.prepend OperatingSystemDefaults
end
