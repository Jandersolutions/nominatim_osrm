#bin/sh
sudo apt-get update && sudo apt-get upgrade
curl https://raw.githubusercontent.com/ajenti/ajenti/master/scripts/install.sh | sudo bash -s -
sudo pip install ajenti-panel ajenti.plugin.dashboard ajenti.plugin.settings ajenti.plugin.plugins ajenti.plugin.filemanager ajenti.plugin.notepad ajenti.plugin.packages ajenti.plugin.services ajenti.plugin.terminal
sudo apt-get install snapd
sudo snap install docker
sudo docker pull osrm/osrm-backend
sudo docker pull osrm/osrm-frontend
sudo docker pull mediagis/nominatim
sudo docker pull hasura/graphql-engine
cd
mkdir nominatimdata
cd nominatimdata
wget -c http://download.geofabrik.de/south-america/brazil-latest.osm.pbf
cd
docker run -t -v "${PWD}:/data" mediagis/nominatim  sh /app/init.sh /data/brazil-latest.osm.pbf postgresdata 4# sudo docker run --restart=always -p 6432:5432 -p 7070:8080 -d --name mediagis/nominatim -v /home/passdriver/nominatimdata/postgresdata:/var/lib/postgresql/11/main nominatim bash /app/start.sh
# sudo docker run --restart=always -p 6432:5432 -d --name mediagis/nominatim -v /home/passdriver/nominatimdata/postgresdata:/var/lib/postgresql/11/main nominatim sh /app/startpostgres.sh
# local.php -> @define('CONST_Database_DSN', 'pgsql://nominatim:password1234@192.168.1.128:6432/nominatim'); // <driver>://<username>:<password>@<host>:<port>/<database>
# sudo docker run --restart=always -p 7070:8080 -d -v /home/passdriver/nominatimdata/conf:/data nominatim sh /app/startapache.sh
# local.php -> @define('CONST_Replication_Url', 'http://download.geofabrik.de/south-america/brazil-updates/');
sudo docker run -t -v "${PWD}:/data" osrm/osrm-backend osrm-extract -p /opt/car.lua /nominatimdata/brazil-latest.osm.pbf 
sudo docker run -t -v "${PWD}:/data" osrm/osrm-backend osrm-partition /nominatimdata/brazil-latest.osrm
sudo docker run -t -v "${PWD}:/data" osrm/osrm-backend osrm-customize /nominatimdata/brazil-latest.osrm
# sudo docker run -t -i -p 5000:5000 -v "${PWD}:/data" osrm/osrm-backend osrm-routed --algorithm mld /data/brazil-latest.osrm
# sudo docker run -p 9966:9966 osrm/osrm-frontend
