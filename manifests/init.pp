# @summary Setup a host to be administrable by users
#
# Setup basics to ease administrators to connect to nodes through SSH and run sudo
#
# Additionnally, it configures root's zsh to use the user's .zshrc if a root shell is opended using sudo
#
# Administrators must be defined in hiera through the root key: 'administrators'
#
# @example
# In node definition:
#   include administrable_as_user
#
# In hiera:
# ---
# administrators:
#   johndoe:
#     shell: '/bin/zsh'
#     ssh_keys:
#       - 'ssh-rsa RSA_PUBLIC_KEY john@supercomputer.example.com'
#       - 'ssh-ed25519 ED25519_PUBLIC_KEY jdoe@anywhere'
class administrable_as_user {
  $administrators = lookup('administrators')

  user { 'root':
    ensure         => present,
    home           => '/root',
    password       => '*',
    purge_ssh_keys => true,
    uid            => 0,
  }

  $root_zshrc = @(EOT)
    if [ -n "$SUDO_USER" -a -f "/home/$SUDO_USER/.zshrc" ]; then
      . "/home/$SUDO_USER/.zshrc"
    fi
    | EOT

  file { '/root/.zshrc':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $root_zshrc,
  }

  ssh::allowgroup { 'adm': }

  create_resources(administrable_as_user::admin, $administrators, { ensure => 'present' })
}
