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
      path << vendor_dir if vendor_dir && File.directory?(vendor_dir)
      path
    end

    def operating_system_defaults
      { 'custom_shebang' => '/usr/bin/env ruby' }
    end

    def default_specifications_dir
      @default_specifications_dir ||= File.join(orig_default_dir, "specifications", "default")
    end

  private
    def gentoo_dir
      @gentoo_dir ||= RbConfig::CONFIG['sitelibdir'].gsub('site_ruby', 'gems')
    end

    def gentoo_local_dir
      @gentoo_local_dir ||= gentoo_dir.gsub('/usr', '/usr/local')
    end

    def gentoo_user_dir
      @gentoo_user_dir ||= Process.euid.zero? ? gentoo_local_dir : orig_user_dir
    end

    def gentoo_user_bindir
      @gentoo_user_bindir ||= Process.euid.zero? ? '/usr/local/bin' : File.join(user_home, 'bin')
    end

    def orig_default_dir
      method(:default_dir).super_method.call
    end

    def orig_user_dir
      method(:user_dir).super_method.call
    end
  end

  self.singleton_class.prepend OperatingSystemDefaults
end
