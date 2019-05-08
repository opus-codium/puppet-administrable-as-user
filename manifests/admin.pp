# @summary Setup an admin account
#
# This defined type is used to declare each administrator.
#
# It creates user account (set shell, create home directory, etc.) and add declared SSH keys.
#
# @example
#   administrable_as_user::admin { 'adminisraptor':
#     shell => '/bin/zsh',
#   }
define administrable_as_user::admin (
  Enum['present', 'absent'] $ensure = present,
  String $password = '*',
  String $shell = '/bin/bash',
  Array[String] $ssh_keys = [],
) {
  user { $name:
    ensure         => $ensure,
    groups         => [
      'adm',
      'sudo',
    ],
    shell          => $shell,
    home           => "/home/${name}",
    managehome     => true,
    password       => $password,
    purge_ssh_keys => true,
  }

  $ssh_keys.each |$user_ssh_key| {
    administrable_as_user::user_ssh_key { $user_ssh_key:
      user => $name,
    }
  }
}
