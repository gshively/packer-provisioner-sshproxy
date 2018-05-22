import testinfra

def test_squid_pkg(host):
    squid_pkg = host.package('squid')
    assert squid_pkg.is_installed

def test_squid_conf(host):
    squid_conf = host.file('/etc/squid/squid.conf')
    assert squid_conf.exists