import testinfra

def test_testfile(host):
    sut = host.file('/tmp/a_test_file')
    assert sut.exists

def test_test2(host):
    sut = host.file('/tmp/a_second_file')
    assert sut.exists
