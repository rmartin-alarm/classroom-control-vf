class users::admins {
  users::managed_user { 'jose': }
  users::managed_user { 'alice':
    gname => 'admins',
  }
  users::managed_user { 'chen':
    gname => 'admins',
  }
}
