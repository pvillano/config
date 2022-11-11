# Jackett setup
* Add Indexer
  * Filter-> public
  * click on a bunch idk
  * save
# Radarr, Sonarr setup
* Settings->Download Clients->+
  * Torrents-> qBittorrent
    * Name: qBittorrent
    * host: gluetun
    * Username:
    * Password:
* Settings-> Indexers -> Add Indexer
  * Torrents -> Torznab -> Custom
    * Name: <blah>
    * URL:
      * replace this http://localhost:9117/api/v2.0/indexers/<blah>/results/torznab/
      * with this    http://jackett:9117/api/v2.0/indexers/<blah>/results/torznab/
* Settings -> Media Management -> Root Folders
  * Sonarr: /data/tv
  * Radarr: /data/movies