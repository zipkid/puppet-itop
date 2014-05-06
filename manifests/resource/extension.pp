#  iTop Custom Extensions installation.
#
#  Valid for own created extenstions and TeemIP.
#
#  Requirements:   - Source file must be a zip file
#                  - Internal structure for the zip is:
#                            web/extensions/<extension directory name>
#
define itop::resource::extension (
  $zip_url    = $itop::zip_url,
  $target     = $itop::ext_dir,
  $zip_target = $itop::zip_dir,
)
{
  archive { $name:
    ensure     => present,
    checksum   => true,
    extension  => 'zip',
    url        => "${zip_url}/${name}.zip",
    target     => $target,
    src_target => $zip_target,
  }
}
