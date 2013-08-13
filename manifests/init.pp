class sogo {
    realize(
        User["sogo"],
        Group["sogo"],
    )
    $packages = [ "sogo", "sope49-gdl1-postgresql", "httpd", "sogo-tool" ]
    package { $packages:
        ensure => installed,
    }

    $sogodirs = [ "/home/sogo", "/home/sogo/GNUstep/", "/home/sogo/GNUstep/Defaults/", "/var/log/sogo", "/var/spool/sogo" ]
    file { $sogodirs:
        ensure => "directory",
        owner   => sogo,
        group   => sogo,
        mode    => 755,
    }
    file { "/var/run/sogo" :
        ensure => "directory",
        owner   => sogo,
        group   => sogo,
        mode    => 700,
    }
    file { "/home/sogo/GNUstep/Defaults/.GNUstepDefaults":
        owner   => sogo,
        group   => sogo,
        mode    => 600,
        source => [
                "puppet:///modules/sogo/GNUstepDefaults-$fqdn",
                "puppet:///modules/sogo/GNUstepDefaults",
        ],
        notify => Service["sogod"],
    }

    file { "/etc/sysconfig/sogo":
        owner   => root,
        group   => root,
        mode    => 444,
        source => [
                "puppet:///modules/sogo/sysconfig_sogo-$fqdn",
                "puppet:///modules/sogo/sysconfig_sogo",
        ],
        notify  => Service["sogod"],
    }
    # this kills sogod's that's been consuming more than 15m cputime:
    file { "/usr/local/sbin/sogo-watchdog.sh":
        owner   => root,
        group   => root,
        mode    => 555,
        source => [
                "puppet:///modules/sogo/sogo-watchdog.sh-$fqdn",
                "puppet:///modules/sogo/sogo-watchdog.sh",
        ],
    }
    file { "/etc/cron.d/sogo-watchdog.cron":
        owner   => root,
        group   => root,
        mode    => 444,
        source => [
                "puppet:///modules/sogo/sogo-watchdog.cron-$fqdn",
                "puppet:///modules/sogo/sogo-watchdog.cron",
        ],
    }
    file { "/etc/httpd/conf.d/01-SOGo-local.conf":
        owner   => root,
        group   => root,
        mode    => 444,
        source => [
                "puppet:///modules/sogo/SOGo-local.conf-$fqdn",
                "puppet:///modules/sogo/SOGo-local.conf",
        ],
        notify  => Service["httpd"],
    }
    file { "/etc/httpd/conf.d/02-SOGo-shared.conf":
        owner   => root,
        group   => root,
        mode    => 444,
        source => [
                "puppet:///modules/sogo/SOGo-shared.conf-$fqdn",
                "puppet:///modules/sogo/SOGo-shared.conf",
        ],
        notify  => Service["httpd"],
    }
    file { "/etc/httpd/conf.d/SOGo.conf":
        owner   => root,
        group   => root,
        mode    => 444,
        source => [
                "puppet:///modules/sogo/SOGo.conf-$fqdn",
                "puppet:///modules/sogo/SOGo.conf",
        ],
        notify  => Service["httpd"],
    }
    file { "/etc/httpd/conf.d/00-apache-server-status.conf":
        owner   => root,
        group   => root,
        mode    => 444,
        source => [
                "puppet:///modules/sogo/00-apache-server-status.conf-$fqdn",
                "puppet:///modules/sogo/00-apache-server-status.conf",
        ],
        notify  => Service["httpd"],
    }
    service { "httpd":
        ensure => true,
        enable => true,
        require => [ File["/etc/httpd/conf.d/SOGo.conf"], Package["httpd"], ],
    }

    service { "sogod":
        ensure => true,
        enable => true,
        start => "/usr/local/sbin/sogo-services.sh start",
        stop => "/usr/local/sbin/sogo-services.sh stop",
        require => [ File["/home/sogo/GNUstep/Defaults/.GNUstepDefaults"], Package["sogo"], Package["sope49-gdl1-postgresql"], File['/usr/local/sbin/sogo-services.sh'], ],
    }

    # Script to make sure all sogod's are dead before starting them.. Also manages keepalived daemon:
    file { "/usr/local/sbin/sogo-services.sh":
        owner   => root,
        group   => root,
        mode    => 755,
        source => [
                "puppet:///modules/sogo/sogo-services.sh-$fqdn",
                "puppet:///modules/sogo/sogo-services.sh",
        ],
    }
}
