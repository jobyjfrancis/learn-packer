#!/bin/bash
set -ex

## Note to future readers:
##
## If you wish to change something, please add it to the "base" template
## using hiera or puppet manifest, instead of adding it here. This script
## is only used for bootstrapping puppet.
##

export DEBIAN_FRONTEND=noninteractive

wget -q https://apt.puppetlabs.com/puppet6-release-jammy.deb -O /tmp/puppet6-release-jammy.deb
dpkg -i /tmp/puppet6-release-jammy.deb
rm /tmp/puppet6-release-jammy.deb

apt-get update
apt-get -y \
	-o Dpkg::Options::="--force-confdef" \
	-o Dpkg::Options::="--force-confold" \
	dist-upgrade

# todo: the only thing we should ideally have to do is install puppet here, but
# there are dependencies like librarian-puppet that need to be installed so that
# bake scripts work correctly.
apt-get install -y git puppet-agent ruby

gem install librarian-puppet -v 3.0.0 --no-document

if [[ ! -f /usr/local/bin/librarian-puppet ]]; then
    ln -s /usr/local/bin/librarian-puppet /usr/bin/librarian-puppet
fi;

/opt/puppetlabs/puppet/bin/gem install toml-rb --no-document

# TODO dump this?
# Puppet 6.14 contains a bug that prevents the use of `recurse` in `file` blocks, which was fixed in an unreleased version
# of Puppet. So that base builds can still be made the patch associated for that bug is applied here if the Puppet version
# is the broken one.
# See https://tickets.puppetlabs.com/browse/PUP-10367
if [[ "$(/opt/puppetlabs/puppet/bin/puppet --version)" == "6.14.0" ]]; then
  echo "Applying patch for PUP-10367"
  sed -i 's/chunk_file_from_disk(metadata.path, &block)/chunk_file_from_disk(metadata.full_path, \&block)/g' /opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet/type/file/source.rb
fi
