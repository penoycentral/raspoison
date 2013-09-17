# == Class: raspoison
#
# Puppet module to install and configure a simple web chromium kiosk mode using ratpoison running on raspberrypi+raspbian
# http://penoycentral.net/linuxnix/raspberrypiraspbianratpoison
# http://ratpoison.nongnu.org/
#
#
# === Authors
#
# Chris Perez <penoycentralatgmaildotcom>
#
# === Copyright
#
class raspoison {

$pkg_install = ['ratpoison', 'chromium', 'x11vnc', 'x11-xserver-utils']

  package { $pkg_install :
    ensure => installed,
  }

augeas {"inittab":
  context => "/files/etc/inittab",
  changes => [
    "set 1/runlevels 12345",
    "set 1/action respawn",
    "set 1/process \"/bin/login -f pi tty1 </dev/tty1 >/dev/tty1 2>&1 \" ",
  ]
}

  file { '/home/pi/.xinitrc':
    ensure  => present,
    content => "exec ratpoison",
    owner   => 'pi',
    group   => 'pi',
  }

  file { "/home/pi/.bash_profile":
    ensure  => present,
    content => 'if [ -z "$DISPLAY" ] && [ $(tty) == /dev/tty1 ]; then startx ;fi',
    owner   => 'pi',
    group   => 'pi',
  }

  file { '/home/pi/.ratpoisonrc':
    source => "puppet:///modules/raspoison/ratpoisonrc",
    owner  => 'pi',
    group  => 'pi',
  }


}

