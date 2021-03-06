define users::managed_user (
  $gname  = $title
) {
  File {
    owner   => $title,
    group   => $gname,
  }
  
  group { $gname :
    ensure  => present,
  }
  
  user  { $title :
    ensure    => present,
    groups    => $gname,
    shell     => '/bin/bash',
  }
  
  file { "/home/$title" :
    ensure  => directory,
    mode    => '0750',
  }
  
  file { "/home/$title/.ssh" :
    ensure  => directory,
    mode    => '0600',
    require => File["/home/$title"],
  }
}
