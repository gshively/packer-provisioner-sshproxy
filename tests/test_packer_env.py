import testinfra
import os

def test_packer_env(host):
    assert 'PACKER_BUILDER_TYPE' in os.environ
    assert 'PACKER_BUILD_NAME' in os.environ

    assert 'docker' == os.environ.get('PACKER_BUILDER_TYPE')
