# overlay

An overlay for Gentoo Linux's Portage.

## Usage

Add the repository using eselect-repository:

    eselect repository enable konsolebox

Or add it manually:

    eselect repository add konsolebox git https://github.com/konsolebox/overlay.git

Or create a `konsolebox.conf` file in `/etc/portage/repos.conf/`:

    curl -o /etc/portage/repos.conf/konsolebox.conf \
            https://raw.githubusercontent.com/konsolebox/overlay/master/konsolebox.conf.example

The file should contain something like this:

    [konsolebox]
    auto-sync = yes
    location = /var/db/repos/konsolebox
    masters = gentoo
    sync-type = git
    sync-uri = https://github.com/konsolebox/overlay.git

Run initial sync after.

    emerge --sync
