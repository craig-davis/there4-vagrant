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
    'mysql.create-c5-db':
      unless => "mysql -u${params::dbuser} -p${params::dbpass} ${params::dbname}",
      path    => '/bin:/usr/bin',
      command => "mysql -uroot -proot -e \"create database ${params::dbname};\"",
      require => Exec["mysql.password"]
  }

  exec {
    'mysql.populate-c5-db':
      unless => "mysql -u${params::dbuser} -p${params::dbpass} ${params::dbname}",
      path    => '/bin:/usr/bin',
      command => "mysql -uroot -proot ${params::dbname} < ${params::dbfile}",
      require => Exec["mysql.create-c5-db"]
  }

  exec {
    'mysql.permissions-c5-db':
      path    => '/bin:/usr/bin',
      command => "mysql -uroot -proot -e \"grant all privileges on ${params::dbname}.* to ${params::dbuser}@localhost identified by '${params::dbpass}';\"",
      require => Exec["mysql.populate-c5-db"]
  }

  exec {
    'mysql.create-report-db':
      unless => "mysql -u${params::dbuser_report} -p${params::dbpass_report} ${params::dbname_report}",
      path    => '/bin:/usr/bin',
      command => "mysql -uroot -proot -e \"create database ${params::dbname_report};\"",
      require => Exec["mysql.password"]
  }

  exec {
    'mysql.populate-report-db':
      unless => "mysql -u${params::dbuser_report} -p${params::dbpass_report} ${params::dbname_report}",
      path    => '/bin:/usr/bin',
      command => "mysql -uroot -proot ${params::dbname_report} < ${params::dbfile_report}",
      require => Exec["mysql.create-report-db"]
  }

  exec {
    'mysql.permissions-report-db':
      path    => '/bin:/usr/bin',
      command => "mysql -uroot -proot -e \"grant all privileges on ${params::dbname_report}.* to ${params::dbuser_report}@localhost identified by '${params::dbpass_report}';\"",
      require => Exec["mysql.populate-report-db"]
  }

  exec {
    'mysql.permissions-root':
      path    => '/bin:/usr/bin',
      command => "mysql -uroot -proot -e \"grant all privileges on *.* to root@'%' identified by 'root';\"",
      require => Exec["mysql.permissions-report-db"]
  }

}
