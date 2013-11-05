class impala::worker (
    $impala_state_store_host = $::impala::defaults::impala_state_store_host,
    $impala_state_store_port = $::impala::defaults::impala_state_store_port,
    $impala_backend_port = $::impala::defaults::impala_backend_port,
    $release = $::impala::defaults::release,

) inherits impala::defaults {

    # Workaround to pass parameters to base class in puppet 2.7.
    class { 'impala':
        release => $release
    }
    Class['impala'] -> Class['impala::worker']

    package { ['impala-server', 'impala']:
        ensure  => installed,
    }


    file { '/etc/impala/conf/hive-site.xml':
        owner   => 'impala',
        group   => 'impala',
        source  => '/etc/hive/conf/hive-site.xml',
        require => Package['impala-server'],
        notify  => Service['impala-server'],
    }

    file { '/etc/impala/conf/hdfs-site.xml':
        owner   => 'impala',
        group   => 'impala',
        source  => '/etc/hadoop/conf/hdfs-site.xml',
        require => Package['impala-server'],
        notify  => Service['impala-server'],
    }
    file { '/etc/impala/conf/core-site.xml':
        owner   => 'impala',
        group   => 'impala',
        source  => '/etc/hadoop/conf/core-site.xml',
        require => Package['impala-server'],
        notify  => Service['impala-server'],
    }

    file { '/etc/default/impala':
        owner   => 'root',
        group   => 'root',
        content => template('impala/impala-default.erb'),
        require => Package['impala-server'],
        notify  => Service['impala-server'],
    }
     
    service { 'impala-server':
        ensure     => 'running',
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        require    => [File['/etc/impala/conf/core-site.xml'], File['/etc/impala/conf/hdfs-site.xml'], File['/etc/impala/conf/hive-site.xml'], Package['impala-server']],
    }
}
