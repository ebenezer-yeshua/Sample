class mydevops_postgresql_bdr::afmydevopscom {

  ssh_authorized_key { 'barman@af1-mydevops-virt-ewr1':
    ensure =>  present,
    user   => 'postgres',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC9zo1gRMMOA9ZA6GO6w9kff+OFhKyXrlaB8d2v63BHpGLBlqTk/htXP7/ZDbnam2A+NP8ig2JfI4CsXWGutH7DUilYHp9l/o1/ludtDx1ry20D4HzQmaC6C4Ah3eyMStJF49o2ocMTnT/CwLK6M1Z9zu0CAShdU8mZLtL7Gb4x1rFm8o9Q7JH3uJs+zJmiMqKy8lRqp2/ySCVfizMw/Uiu9HfZpZ8Ev/gGf6FM5NfZx3KqEPuQeLYJKtwSV+GT4Wk3jZTxA86baGOsgiTwZPnSuqB2XrizwN3l90/h6FiyqExG2MZC7LJaSyPma3CFGT35boEbbdjA4KeJRkCT7AVh',
  }
  ssh_authorized_key { 'postgres@af1-mydevops-virt-ewr1':
    ensure =>  present,
    user   => 'barman',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC7HTAuzZk94TEDIv9OLV6NCcpsfPNAaehAxB7GXqh8UkkJeIsuldE2+u0JxHm0a+JBCaMmkiArq9op2Q6AsGxlk3A5g6Aye+0H+HAPNNNmKJt6hcNju+lQIbh0jYa4DOTFcw3pnobT2pfefd78IEP6r7mcFa80iN8B4V/GppOji19Gr4HIDoLV47zafgAQnKxrYLZk6z1AV6NL6oMrX/b2HRJJaU7ViaiJWqKcsrfIsVC5NO4XrghnXrjlZsrKREZTtNS6JhY03wb/AZSddFYhj5Kb/f7PuPa38BBYy+rYce1FzCcNSFdUsJrMC3nxUL821dOFhk8q0jWoQF1Ui1pX',
  }
  ssh_authorized_key { 'barman@af2-mydevops-virt-ewr1':
    ensure =>  present,
    user   => 'postgres',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDB3bXR7RmOGtSc9ueVzvljMz0Dn6zGUfBAk85omaLK6ROyNyNjAAVH61qM/FwCaQgI1S+xx2g82j5emKsb0S49grk3gDN97YAfcBJzQxodWBoB09JdbcQFlZuQtMenPYEn8aLORV080+fooyVMhZ7J5HSkMR1uY3kFFwspdXAmwJ9KkExJbqIJzLqLbnTAUQA+g8LnN3WwKTnF21RzobqKZZeJJipP4Y4DbXpFBwx1avaDMZ1iQ06I3rfoXFpCfz5Xr3zisN50lxtCKCfZSDlXw4B9R5j7Jet7Z26ID0u6i/DufP1aoAuo6Fjr5nuLd56zfrmSTlz4CEiwlWPomvA7',
  }
  ssh_authorized_key { 'postgres@af2-mydevops-virt-ewr1':
    ensure =>  present,
    user   => 'barman',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCXRiqez0Fu2hKomR1TR15i0CVNvS8DW0FqefOgPqIQlbeMqQUIj1uovYlQ2+u6SLXGp44XN4/38I2tSECfxcHscSB84QOAa4V6AGO5DHk53eQMK3Jin+Xy0/RGcURH/iQLn7MUuf92Zs3rUvtltJCiQQevImyjUPgWJeSiy8Jy31M17nUU+YPAvf4Sfd5F8HPfJ6dgSCd5KuZ3vH/y0wgCJivWXrVTFzQGQoqrwMtk8m/zoA0oKLkYii9JJLGDEvkf2zbVRMsy9bp9AqG95IS3DdLgrv4uTuCKKFwiPnyV/URAcuzqur4fnBimgxeIVOmuQIZZR7lLv4MJNtENY00r',
  }
}
