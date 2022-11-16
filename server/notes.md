# Server setup
* Install ubuntu
* Install docker and docker-compose
* clone the repo
* doublecheck the .env
* docker-compose up

# Jackett setup
* port 9117
* Add Indexer
  * Filter-> public
  * click on a bunch idk
  * save
# Radarr, Sonarr setup
* ports 7878 and 8989
* Settings->Download Clients->+
  * Torrents-> qBittorrent
    * Name: qBittorrent
    * host: gluetun
    * Username:
    * Password:
* Settings -> Download Clients -> Remote Path Mappings
  * Host: gluetun
  * Remote Path /downloads/
  * Local Path /data/downloads/
* Settings-> Indexers -> Add Indexer
  * Torrents -> Torznab -> Custom
    * Name: <blah>
    * URL:
      * replace this http://localhost:9117/api/v2.0/indexers/<blah>/results/torznab/
      * with this    http://jackett:9117/api/v2.0/indexers/<blah>/results/torznab/
* Settings -> Media Management -> Root Folders
  * Sonarr: /data/tv
  * Radarr: /data/movies
* Settings -> Media Management -> Episode Naming
  * Series Folder Format
    * {Series TitleTheYear} [tvdbid-{TvdbId}]
  * Season Folder Format
    * Season {season:00}
  * Specials Folder Format
    * Season 00
  * Multi-Episode Style
    * Range
  * Movie Folder Format
    * {Movie TitleThe} ({Release Year}) [tmdbid-{TmdbId}]
# Jellyfin setup
* Follow wizard
  * Setup your media libraries
    * Movies /data/movies
    * Shows /data/tvshows