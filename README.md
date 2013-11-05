# Puppet module for Impala


Puppet module for installing Impala on your Hadoop cluster.






### Dependencies not made explicit in the module itself:


- Oracle Java 6 installed on all nodes (requirement of Impala).
- Apache Hive and Hadoop should be installed on the worker nodes (The CDH4 versions included in: https://github.com/wikimedia/puppet-cdh4 ).


### Usage:


On the master node:
```puppet
class {'impala::master':
    require => Class['your::class::that::ensures::java::is::installed'],
}
```

On the worker nodes:
```puppet
class {'impala::worker':
    impala_state_store_host => $master_fqdn,
    require => [Class['your::class::that::ensures::java::is::installed'], Class['cdh4::hive']],
}
```
