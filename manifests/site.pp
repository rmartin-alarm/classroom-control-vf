## site.pp ##

# This file (/etc/puppetlabs/puppet/manifests/site.pp) is the main entry point
# used when an agent connects to a master and asks for an updated configuration.
#
# Global objects like filebuckets and resource defaults should go in this file,
# as should the default node definition. (The default node can be omitted
# if you use the console and don't define any other nodes in site.pp. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.)

## Active Configurations ##

# PRIMARY FILEBUCKET
# This configures puppet agent and puppet inspect to back up file contents when
# they run. The Puppet Enterprise console needs this to display file contents
# and differences.

# Disable filebucket by default for all File resources:
File { backup => false }

# Randomize enforcement order to help understand relationships
ini_setting { 'random ordering':
  ensure  => present,
  path    => "${settings::confdir}/puppet.conf",
  section => 'agent',
  setting => 'ordering',
  value   => 'title-hash',
}

# DEFAULT NODE
# Node definitions in this file are merged with node data from the console. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.

# The default node definition matches any node lacking a more specific node
# definition. If there are no other nodes in this file, classes declared here
# will be included in every node's catalog, *in addition* to any classes
# specified in the console for that node.

node default {
  # This is where you can declare classes for all nodes.
  # Example:
  #   class { 'my_class': }
  include role::classroom
  #include users
  include skeleton
  #class { 'nginx' : root => '/var/www', } #using console instead
  
  #file { '/etc/motd' :
  #  ensure  => file,
  #  owner   => 'root',
  #  group   => 'root',
  #  mode    => '0644',
  #  content => "Pretty girl beware of this heart of gold. This heart is cold!\n",
  #}
  $hieraMOTD = hiera('message')
  notify { "hiera: $hieraMOTD": }
  
  if $::virtual != 'physical' {
    $vmType = capitalize($facts['virtual'])
    notify { "It is not the spoon that bends, it is $vmType": }
  }
  
  exec { 'do_welcome' :
    path => ['/usr/local/bin', '/bin'],
    command => 'cowsay -f Daemon "Such a cold finger. Beckons you to enter your web of sin, but don\'t go in!" > /etc/motd',
    unless  => "grep -e \"cold finger\" /etc/motd",
  }
}
