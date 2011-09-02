#!/usr/bin/env ruby

require 'rubygems'
require 'fog'

# Initiate a connection to AWS
connection = Fog::Compute[:aws]

# Create an appropriate security group
security_group = connection.security_groups.create({:name => 'mwf-http', :description => 'Allow http/https access to the MWF'})
security_group.authorize_port_range(22..22)
security_group.authorize_port_range(80..80)
security_group.authorize_port_range(443..443)

# Generate a new interface
server = connection.servers.bootstrap(
   :name => 'mwf-demo',
   :private_key_path => '~/.ssh/id_rsa', 
   :public_key_path => '~/.ssh/id_rsa.pub', 
   :username => 'ec2-user', 
   :image_id => 'ami-3f0bcb56',
   :groups => ['default', 'mwf-http']
)

# Install puppet and setup a place to drop the manifest
server.ssh([
   'sudo yum -y install puppet git',
   'sudo git clone git://github.com/cwebberOps/mwf-puppet.git /usr/share/puppet/modules/mwf',
   "sudo puppet apply -e \"class {'mwf::server': site_url => 'http://#{server.dns_name}/mobile', site_assets_url => 'http://#{server.dns_name}/mobile/assets'}\""
])

###
puts "sudo puppet apply -e \"class {'mwf::server': site_url => 'http://#{server.dns_name}/mobile', site_assets_url => 'http://#{server.dns_name}/mobile/assets'}\""
###
puts server.dns_name
puts "http://#{server.dns_name}/mobile"
