define users::managed_user (
  $gname  = $gname,
  $password = $password
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
    password  => "$password",
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
