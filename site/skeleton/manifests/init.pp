class skeleton {
  file { '/etc/skel' :
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
  }
  
  file { '/etc/skel/.bashrc' :
    ensure  => file,
    source  => 'puppet:///site/skeleton/bashrc',
    owner   => 'root',
    group   => 'root',
    require => File['/etc/skel'],
  }
}
