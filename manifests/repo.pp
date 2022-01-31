# @summary (Un-) Installs a repository along with its GPG key.
#
# This is a utility type that is used by the nvdarepo class. It is not intended
# for direct use by end users. One main feature of the type is that it can
# compute the repository location based on the current layou of NVIDIA's server
# from the OS information provided by Puppet.
#
# @param base_url The base URL where NVIDIA's repositories are located. If no
#                 repo_src is provided, the module will construct the URL from
#                 this base URL using the known way NVIDIA is organising their
#                 server.
# @param version_field This parameter determines which of the version facts is
#                      used to automatically construct the URL of the
#                      repository. The parameter defaults to 'major', ie the
#                      major version of the distribution is used to construct
#                      the repository source.
# @param repo_src_override Overrides the generated URL of the repository file
#                          with the specified value.
# @param distro_override Overrides the name in the distribution for the purpose
#                        of generating the repository URL. This value is only
#                        used when repo_src_override is not set.
# @param repo_dir The directory where to install the repository file, ie
#                 "/etc/yum.repos.d" for RedHat-based systems.
# @param repo_ext The extension of the repository file, typically ".repo".
# @param repo_owner The name or UID of the owning user of the repository file.
# @param repo_group The name or UID of the owning group of the repository file.
# @param key_id The ID of the GPG key used by the repository.
# @param key_file_name The name of the GPG key file to be installed.
# @param key_src_override Override the full URL of from which the GPG key is
#                         retrieved. Otherwise, the key is searched in the
#                         repository directory.
# @param key_dir The directory where the key should be installed. This is only
#                used on RedHat-based systems.
# @param key_prefix An additional prefix string that is added before the
#                   name of the key file. This is only used on RedHat-based
#                   systems and should be something like "RPM-GPG-KEY-".
# @param ensure Determines whether the repository should be present or absent.
#               This defaults to "present".
#
# @author Christoph Müller
define nvdarepo::repo(
        String $base_url,
        String $version_field,
        Variant[String, Boolean] $repo_src_override = false,
        Variant[String, Boolean] $distro_override = false,
        String $repo_dir,
        String $repo_ext,
        Variant[String, Integer] $repo_owner,
        Variant[String, Integer] $repo_group,
        String $key_id,
        String $key_file_name,
        Variant[String, Boolean] $key_src_override = false,
        String $key_dir,
        String $key_prefix,
        String $ensure = present
        ) {

    # Determine the final URL of the repository according to the rules used by
    # NVIDIA to organise their server.
    $nvda_distro = if ($distro_override) {
        $distro_override
    } else {
        downcase($facts['os']['name'])
        
    }
    $nvda_version = regsubst(downcase($facts['os']['release'][$version_field]),
        '\\.', '')
    $dist_url = if ($repo_src_override) {
        $repo_src_override
    } else {
        "${base_url}/${nvda_distro}${nvda_version}/x86_64"        
    }
    $key_url = if ($key_src_override) {
        $key_src_override
    } else {
        "${dist_url}/$key_file_name"
    }

    # Install the GPG key and the repository.
    case $facts['os']['family'] {
        'RedHat': {
            # (Un-) Install the repository GPG key.
            unless ($key_url == undef) {
                yum::gpgkey { "${key_dir}/${key_prefix}${title}":
                    ensure => $ensure,
                    source => $key_url,
                }
            }

            # (Un-) Install the repo definition.
            class { 'yum':
                managed_repos => [ $title ],
                repos => {
                    $title => {
                        ensure => $ensure,
                        descr => $title,
                        gpgcheck => true,
                        baseurl => $dist_url,
                        target => "${repo_dir}/${title}${repo_ext}"
                    }
                }
            }
        }

        default: {
            fail(translate('The current distribution is not supported by ${title}.'))
        }
    }
}
