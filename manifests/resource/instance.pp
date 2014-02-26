#
# Class itop::resource::instance
#
define itop::resource::instance (
  $installdir,
  $docroot,
  $user           = 'apache',
  $group          = 'apache',
  $extensions     = [],
  $database       = undef,
  $url            = undef,
  $admin_account  = undef,
  $modules        = undef,
  $src_dir        = $itop::params::itop_src_dir,
) {

  file { [ $installdir ]:
    ensure  => directory,
    mode    => '0755',
    #recurse => true,
  }

  $ext_str = join($extensions, ',')

  exec { "iTop_install_${name}":
    command => "/usr/local/itop/bin/install_itop_site --root ${docroot} --source ${src_dir} --user ${user} --group ${group} --extensions ${ext_str}",
    unless  => "/usr/local/itop/bin/install_itop_site --check --root ${docroot} --source ${src_dir} --user ${user} --group ${group} --extensions ${ext_str}",
    require => File["${docroot}/extensions"],
  }

  cron { "iTop_cron_${name}":
    command => "/usr/bin/php ${docroot}/webservices/cron.php --param_file=${docroot}/webservices/cron.params &> /dev/null",
  }

  file { "${docroot}/toolkit/unattended-install.php":
    ensure  => present,
    mode    => '0644',
    source  => 'puppet:///modules/itop/unattended-install.php',
    require => Exec["iTop_install_${name}"],
  }

  #file { $docroot:
    #ensure  => directory,
    #mode    => '0644',
    #recurse => true,
    #require => Exec["iTop_install_${name}"],
  #}

  file { [ "${docroot}/conf", "${docroot}/data", "${docroot}/env-production",
            "${docroot}/extensions", "${docroot}/log" ]:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0750',
    require => File[$installdir],
    #recurse => true,
  }

}