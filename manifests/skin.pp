class sogo::skin inherits sogo {
    file { "/usr/lib64/GNUstep/SOGo/WebServerResources/altibox.js":
        owner   => root,
        group   => root,
        mode    => 444,
        source => "puppet:///modules/sogo/skin/WebServerResources/altibox.js",
        require => Package["sogo"],
    }
    file { "/usr/lib64/GNUstep/SOGo/WebServerResources/iefixes.css":
        owner   => root,
        group   => root,
        mode    => 444,
        source => "puppet:///modules/sogo/skin/WebServerResources/iefixes.css",
        require => Package["sogo"],
    }
    file { "/usr/lib64/GNUstep/SOGo/WebServerResources/altibox.css":
        owner   => root,
        group   => root,
        mode    => 444,
        source => "puppet:///modules/sogo/skin/WebServerResources/altibox.css",
        require => Package["sogo"],
    }
    file { "/usr/lib64/GNUstep/SOGo/WebServerResources/altibox":
        ensure  => "directory",
        owner   => root,
        group   => root,
        mode    => 755,
        recurse => true,
        purge   => true,
        source => "puppet:///modules/sogo/skin/WebServerResources/altibox",
        require => Package["sogo"],
    }
    file { "/home/sogo/GNUstep/Library":
        ensure  => "directory",
        owner   => root,
        group   => root,
        mode    => 755,
        recurse => true,
        purge   => true,
        source => "puppet:///modules/sogo/skin/Library",
        require => Package["sogo"],
        notify  => Service["sogod"],
    }
    file { "/var/www/partnerlogos":
        ensure  => "directory",
        owner   => root,
        group   => root,
        mode    => 755,
        recurse => true,
        purge   => true,
        source => "puppet:///modules/sogo/skin/partnerlogo",
        require => Package["sogo"],
    }
}
