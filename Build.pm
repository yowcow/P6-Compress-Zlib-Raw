use Shell::Command;
use NativeCall;

# test sub for system library
our sub zlibVersion() returns Str is encoded('ascii') is native('zlib1.dll') is export { * }

class Build {
    method build($workdir) {
        my $need-copy = False;

        # we only have .dll files bundled. Non-windows is assumed to have openssl already
        if $*DISTRO.is-win {
            zlibVersion();
            CATCH {
                default {
                    $need-copy = True;
                }
            }
        }

        if $need-copy {
            say 'No system zlib library detected. Installing bundled version.';
            mkdir($workdir ~ '\blib\lib\Compress\Zlib');
            cp($workdir ~ '\native-lib\zlib1.dll', $workdir ~ '\blib\lib\Compress\Zlib\zlib1.dll');
        }
        else {
            say 'Found system zlib library.';
        }
    }

    method isa($what) { return True if $what.^name eq 'Panda::Builder'; callsame }
}
