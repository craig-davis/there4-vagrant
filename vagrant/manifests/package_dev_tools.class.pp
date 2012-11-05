
class package_dev_tools
{

  package
  {
    'git-core':
      ensure  => present
  }

  package
  {
    'subversion':
      ensure  => present
  }

  package
  {
    'vim':
      ensure  => present
  }

  package
  {
    'curl':
      ensure  => present
  }

  package
  {
    'ack':
      ensure  => present
  }

  exec
  {
    'dotfiles':
      creates => '/home/vagrant/.dotfiles',
      path    => '/bin:/usr/bin',
      command => 'su -c "git clone https://github.com/mathiasbynens/dotfiles.git /home/vagrant/.dotfiles && cd /home/vagrant/.dotfiles && ./bootstrap.sh --force" vagrant',
      require => Package['git-core']
  }

}
