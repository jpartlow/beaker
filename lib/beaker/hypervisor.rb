module Beaker
  class Hypervisor

    def configure(hosts)
      @logger.debug "No post-provisioning configuration necessary for #{self.class.name} boxes"
    end

    def self.create type, hosts_to_provision, options, config
      @logger = options[:logger]
      @logger.notify("Beaker::Hypervisor, found some #{type} boxes to create") 
      case type
        when /aix/
          Beaker::Aixer.new hosts_to_provision, options, config
        when /solaris/
          Beaker::Solaris.new hosts_to_provision, options, config
        when /vsphere/
          Beaker::Vsphere.new hosts_to_provision, options, config
        when /fusion/
          Beaker::Fusion.new hosts_to_provision, options, config
        when /blimpy/
          Beaker::Blimper.new hosts_to_provision, options, config
        when /vcloud/
          Beaker::Vcloud.new hosts_to_provision, options, config
        when /vagrant/
          Beaker::Vagrant.new hosts_to_provision, options, config
        end
    end
  end
end

%w( vsphere_helper vagrant fusion blimper vsphere vcloud aixer solaris).each do |lib|
  begin
    require "hypervisor/#{lib}"
  rescue LoadError
    require File.expand_path(File.join(File.dirname(__FILE__), "hypervisor", lib))
  end
end
