# overlay

An overlay for Gentoo Linux's Portage.

## Usage

Add the repository with layman:

    layman -a konsolebox

Or create a `konsolebox.conf` file in `/etc/portage/repos.conf/`.

    curl -o /etc/portage/repos.conf/konsolebox.conf \
            https://raw.githubusercontent.com/konsolebox/overlay/master/konsolebox.conf.example

The file should contain something like this:

    [konsolebox]
    auto-sync = yes
    location = /var/local/overlays/konsolebox
    masters = gentoo
    sync-type = git
    sync-uri = git://github.com/konsolebox/overlay.git

You can change the value of `location`, and the protocol used (i.e., use `https://` instead of `git://`).

Run initial sync after.

    emerge --sync
