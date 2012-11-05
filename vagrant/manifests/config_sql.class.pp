class config_sql
{

  exec
  {
    'mysql.open-port':
      path    => '/bin:/usr/bin',
      command => 'sudo /sbin/iptables -A INPUT -i eth0 -p tcp --destination-port 3306 -j ACCEPT'
  }

  file
  {
    'mysql.config':
      path    => '/etc/mysql/my.cnf',
      ensure  => present,
      source  => '/vagrant/vagrant/resources/app/etc/mysql/my.cnf'
  }

  exec
  {
    'mysql.restart':
      path    => '/bin:/usr/bin',
      command => 'sudo service mysql restart',
      require => File["mysql.config"]
  }

  exec
  {
    'mysql.password':
      unless  => 'mysqladmin -uroot -proot status',
      path    => '/bin:/usr/bin',
      command => 'mysqladmin -uroot password root',
      require => Exec["mysql.restart"]
  }

  exec {
    'mysql.create-db':
      unless => "mysql -u${params::dbuser} -p${params::dbpass} ${params::dbname}",
      path    => '/bin:/usr/bin',
      command => "mysql -uroot -proot -e \"create database ${params::dbname};\"",
      require => Exec["mysql.password"]
  }

  exec {
    'mysql.populate-db':
      unless => "mysql -u${params::dbuser} -p${params::dbpass} ${params::dbname}",
      path    => '/bin:/usr/bin',
      command => "mysql -uroot -proot ${params::dbname} < ${params::dbfile}",
      require => Exec["mysql.create-db"]
  }

  exec {
    'mysql.permissions-db':
      path    => '/bin:/usr/bin',
      command => "mysql -uroot -proot -e \"grant all privileges on ${params::dbname}.* to ${params::dbuser}@localhost identified by '${params::dbpass}';\"",
      require => Exec["mysql.populate-db"]
  }

  exec {
    'mysql.permissions-root':
      path    => '/bin:/usr/bin',
      command => "mysql -uroot -proot -e \"grant all privileges on *.* to root@'%' identified by 'root';\"",
      require => Exec["mysql.permissions-db"]
  }

}
