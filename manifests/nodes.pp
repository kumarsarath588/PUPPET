node 'test1.linux.com' {
  
  hiera_include('classes')

  #nginx::resource::upstream { 'guacamole_app':
  #members => [
  #  '192.168.201.211:8080',
  #  '192.168.201.212:8080',
  #],
  #}
  #nginx::resource::vhost { 'guacamole.linux.com':
  #proxy => 'http://guacamole_app',
  #ssl_port          => 443,
  #ssl                  => true,
  #ssl_cert             => '/root/ssl/certs/self-ssl.crt',
  #ssl_key              => '/root/ssl/certs/self-ssl.key',
  #}
  
}

node 'test2.linux.com' {
  
  class { 'linux': }
  class { 'mediawiki': }

}

class linux {
  $admintools = ['git', 'nano', 'screen']

  package { $admintools:
  ensure => 'installed',
  }

  $ntpservice = $osfamily ? {
   'redhat' => 'ntpd',
   'debian' => 'ntp',
   default  => 'ntp',
  }
  file { '/info.txt':
   ensure => 'present',
   content => inline_template("created by puppet at <%= Time.now %>\n"),
  }

  package { 'ntp':
   ensure => 'installed',
  }

  service { $ntpservice:
   ensure => 'running',
   enable => true,
  }
  
}
