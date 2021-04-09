#!/usr/bin/env bash



$(which apt) && pkg_mgr=apt
$(which dnf) && pkg_mgr=dnf
$(which pacman) && pkg_mgr=pacman
$(which eopkg) && pkg_mgr=eopkg

