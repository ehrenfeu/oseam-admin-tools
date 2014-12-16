#!/bin/sh -ex

export LANG=C
export LC_ALL=C

# This script installs a tileserver on Debian Jessie.
## Please take care to make this script idempotent, i.e. running it 
## again should not change anything.

# echo 'deb http://http.debian.net/debian jessie main contrib' > /etc/apt/sources.list

apt-get update
apt-get install -y postgresql postgresql-contrib postgis postgresql-9.4-postgis-2.1 sudo vim

# In the following "openseamap" can be replaced with any username that should
# be used:
sudo -u postgres -i createuser openseamap
sudo -u postgres -i createdb -E UTF8 -O openseamap gis

# Create the system user account:
useradd -m openseamap
echo "openseamap:openseamap" | chpasswd openseamap

# Set up the database:
cd /
sudo -u postgres -i psql gis -c 'CREATE EXTENSION postgis;
ALTER TABLE geometry_columns OWNER TO openseamap;
ALTER TABLE spatial_ref_sys OWNER TO openseamap;
'

apt-get install osm2pgsql python-mapnik mapnik-utils apache2 apache2-dev libmapnik-dev autoconf automake m4 libtool git

# mkdir ~/src
# cd ~/src
# git clone git://github.com/openstreetmap/mod_tile.git
# cd mod_tile
# ./autogen.sh
# ./configure
# make
# sudo make install
# sudo make install-mod_tile
# sudo ldconfig
# 
# (...)
# sudo mkdir /var/run/renderd
# sudo chown openseamap /var/run/renderd
# sudo mkdir /var/lib/mod_tile
# sudo chown openseamap /var/lib/mod_tile/
# 
# osm2pgsql --slim -d gis -C 1000 --number-processes 3 denmark-latest.osm.pbf
# Osm2pgsql took 581s overall

