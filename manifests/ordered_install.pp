# @summary (Un-) Installs packages in a specific order.
#
# Installing CUDA on RHEL systems requires packages being installed in a
# specific order to use the DKMS driver module. This utility class enables
# you to do that by specifying aliases for the packages that define the
# order by means of their lexical order. The keys in the $packages hash
# given to the module determines this order. A dependency relationship
# between these keys will be established by this module. In order to
# specify this order in Hiera, it is best using keys starting with
# numbers like it is common in conf.d directories.
#
# @param packages The $packages parameter is a hash specifying the packages
#                 to be installed. The keys of that hash determine the
#                 order in which the installation happens. The hash should
#                 at least hold the attributes "name" with the actual name
#                 of the package and "ensure" with the installation instruction.
#                 All of the per-package attributes are passed on to the
#                 installation, i.e. you can use every parameter that is
#                 acceptable for the Package resource.
#
# @author Christoph Müller
define nvdarepo::ordered_install(Hash $packages) {
    # Install packages configured via Hiera, making sure that they are invoked
    # in the order they have been specified. The solution has been described at
    # https://stackoverflow.com/questions/70942825/declare-dependency-between-array-elements-in-puppet#70943534
    $orderedPackages = keys($packages).sort

    $orderedPackages.each | Integer $index, String $package | {
        if $index > 0 {
            Package[$orderedPackages[$index - 1]] ~> Package[$package]
        }
    }

    $packages.each | String $package, Hash $attributes | {
        package { $package:
            * => $attributes
        }
    }
}
