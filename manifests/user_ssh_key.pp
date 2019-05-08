# @summary Ease user's SSH key declaration
#
# This defined type declares authorized SSH key through built-in ssh_authorized_key{} but uses the string format used by SSH public key file.
#
# In simplier words, just copy and paste your ~/.ssh/id_*.pub content to this type.
#
# @example
#   administrable_as_user::user_ssh_key { 'ssh-rsa YOUR_KEY user@host':
#     user => 'dummy',
#   }
define administrable_as_user::user_ssh_key (
  String $user,
) {
  $ssh_key = $name.split(' ')
  ssh_authorized_key { $ssh_key[2]:
    ensure => present,
    user   => $user,
    type   => $ssh_key[0],
    key    => $ssh_key[1],
  }
}
