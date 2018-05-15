import testinfra

def test_testfile(host):
    sut = host.file('/tmp/a_test_file')
    assert sut.exists

def test_fail(host):
    assert True
