# Tcl package index file, version 1.0

package ifneeded vfs 1.4.2 [list load "" Vfs]

package ifneeded starkit 1.3.3 [list source [file join $dir starkit.tcl]]
package ifneeded vfs::mk4     1.10.1  [list source [file join $dir mk4vfs.tcl]]
package ifneeded vfs::zip     1.0.4.1 [list source [file join $dir zipvfs.tcl]]
package ifneeded vfs::ftp     1.0 [list source [file join $dir ftpvfs.tcl]]
package ifneeded vfs::http    0.6 [list source [file join $dir httpvfs.tcl]]
package ifneeded vfs::ns      0.5.1 [list source [file join $dir tclprocvfs.tcl]]
package ifneeded vfs::tar     0.91 [list source [file join $dir tarvfs.tcl]]
package ifneeded vfs::test    1.0 [list source [file join $dir testvfs.tcl]]
package ifneeded vfs::urltype 1.0 [list source [file join $dir vfsUrl.tcl]]
package ifneeded vfs::webdav  0.1 [list source [file join $dir webdavvfs.tcl]]
package ifneeded vfs::tk      0.5 [list source [file join $dir tkvfs.tcl]]
