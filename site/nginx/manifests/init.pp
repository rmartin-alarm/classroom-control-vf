class nginx ( 
  $root = undef,
) {
  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
  
  yumrepo { 'updates':
    ensure     => 'present',
    descr      => 'CentOS-$releasever - Updates',
    enabled    => '1',
    gpgcheck   => '1',
    gpgkey     => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7',
    mirrorlist => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates&infra=$infra',
  }
  
  package { 'nginx' :
    ensure  => installed,
    require => Yumrepo['updates'],
  }
  
  file { [ $root ,'/etc/nginx/conf.d/'] :
    ensure  => directory,
  }
  
  file { "$root/index.html" :
    ensure  => file,
    source  => 'puppet:///modules/nginx/index.html',
  }
  
  file { '/etc/nginx/nginx.conf' :
    ensure  => file,
    source  => 'puppet:///modules/nginx/nginx.conf',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }
  
  file { '/etc/nginx/conf.d/default.conf' :
    ensure  => file,
    source  => 'puppet:///modules/nginx/default.conf',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }
  
  service { 'nginx' :
    ensure  => running,
    enable  => true,
    require => Package['nginx'],
  }
}
