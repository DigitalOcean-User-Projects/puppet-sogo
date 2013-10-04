class sogo::install (
  $sogo_db_password
) {
  package { 'sogo':
    ensure => present
  }

  postgresql::user { 'sogo':
    password  => $sogo_db_password,
  }
  postgresql::rights::standard { 'sogo':
    database  => 'sogo',
    user      => 'sogo',
  }
  postgresql::database { 'sogo': }
}
