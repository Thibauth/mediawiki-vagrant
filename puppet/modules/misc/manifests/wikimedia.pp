# == Class: misc::wikimedia
#
# Configures apt to use Wikimedia's package repositories. Note that the
# repository's key is fetched insecurely, making this module inadequate
# for production use.
#
# === Parameters
#
# [*keyurl*]
#   URL of public key for package repositories.
#
class misc::wikimedia(
	$keyurl = 'http://apt.wikimedia.org/autoinstall/keyring/wikimedia-archive-keyring.gpg',
) {
	exec { 'apt-key add wikimedia key':
		command => "curl ${keyurl} | gpg --import && gpg --export --armor Wikimedia | apt-key add -",
		unless  => 'apt-key list | grep -q Wikimedia',
	}

	file { '/etc/apt/sources.list.d/wikimedia.list':
		content => template('misc/wikimedia.list.erb'),
		notify  => Exec['apt-get update'],
		require => Exec['apt-key add wikimedia key'],
	}
}