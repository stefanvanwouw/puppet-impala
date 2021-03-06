class impala::master (
    $impala_service_status = 'running',
    $impala_state_store_host = $::impala::defaults::impala_state_store_host,
    $impala_state_store_port = $::impala::defaults::impala_state_store_port,
    $impala_backend_port = $::impala::defaults::impala_backend_port,
    $release = $::impala::defaults::release,
) inherits impala::defaults {

    # Workaround to pass parameters to base class in puppet 2.7.
    class { 'impala':
        release => $release
    }
    Class['impala'] -> Class['impala::master']

    package { ['impala-state-store', 'impala-catalog']:
        ensure => installed,
    }

    file { '/etc/default/impala':
        owner   => 'root',
        group   => 'root',
        content => template('impala/impala-default.erb'),
        require => Package['impala-state-store'],
        notify  => [Service['impala-state-store'],Service['impala-catalog']],
    }

    service { 'impala-state-store':
        ensure     => $impala_service_status,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        require    => Package['impala-state-store']
    }
    service { 'impala-catalog':
        ensure     => $impala_service_status,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        require    => Package['impala-catalog']
    }
}
