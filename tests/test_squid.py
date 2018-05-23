import testinfra
import os
import re

def test_squid_pkg(host):
    squid_pkg = host.package('squid')
    assert squid_pkg.is_installed

def test_squid_conf(host):
    fname = '/etc/squid/squid.conf'
    squid_conf = host.file(fname)
    assert squid_conf.exists

    localhost_re = re.compile(r'^\s*acl\s+localnet\s+src\s+127\.0\.0\.0\/8')

    content = squid_conf.content_string
    assert None == localhost_re.search(content, re.M)

def test_squid_redirect(host):
    fname = '/etc/sysconfig/iptables'
    iptables_conf = host.file(fname)

    content = iptables_conf.content_string

    assert None != re.search('--dport 80 -j REDIRECT --to-ports 3129', content)
    assert None != re.search('--dport 443 -j REDIRECT --to-ports 3130', content)
