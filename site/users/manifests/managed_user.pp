define users::managed_user (
  $muname  = $title,
  $password = $password
) {
  File {
    owner   => $muname,
    group   => $muname,
  }
  
  group { $muname :
    ensure  => present,
  }
  
  user  { $muname :
    ensure    => present,
    groups    => $muname,
    password  => "$password",
    shell     => '/bin/bash',
  }
  
  file { "/home/$muname" :
    ensure  => directory,
    mode    => '0750',
  }
  
  file { "/home/$muname/.ssh" :
    ensure  => directory,
    mode    => '0600',
    require => File["/home/$muname"],
  }
}
