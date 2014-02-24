class impala (
    $release,
) {


    apt::source {'impala':
        location     => 'http://archive.cloudera.com/impala/ubuntu/precise/amd64/impala',
        release      => $release,
        repos        => 'contrib',
        architecture => 'amd64',
        include_src  => false,
        key          => '02A818DD',
        key_server   => 'keys.gnupg.net',
    }

    package {'impala-shell':
        ensure  => 'installed',
        require => Apt::Source['impala'],
    }
    

}
