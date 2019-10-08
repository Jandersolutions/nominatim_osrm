#bin/sh
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install snapd
sudo snap install docker
sudo docker pull osrm/osrm-backend
sudo docker pull osrm/osrm-frontend
sudo docker pull mediagis/nominatim
mkdir nominatimdata
cd nominatimdata
wget http://download.geofabrik.de/south-america/brazil-latest.osm.pbf
cd
sudo docker run -t -v /home/passdriver/nominatimdata:data mediagis/nominatim sh /app/init.sh /data/brazil-latest.osm.pbf postgresdata 4
sudo docker run --restart=always -p 6432:5432 -p 7070:8080 -d --name mediagis/nominatim -v /home/passdriver/nominatimdata/postgresdata:/var/lib/postgresql/11/main nominatim bash /app/start.sh
sudo docker run --restart=always -p 6432:5432 -d --name mediagis/nominatim -v /home/passdriver/nominatimdata/postgresdata:/var/lib/postgresql/11/main nominatim sh /app/startpostgres.sh
# local.php -> @define('CONST_Database_DSN', 'pgsql://nominatim:password1234@192.168.1.128:6432/nominatim'); // <driver>://<username>:<password>@<host>:<port>/<database>
sudo docker run --restart=always -p 7070:8080 -d -v /home/passdriver/nominatimdata/conf:/data nominatim sh /app/startapache.sh
# local.php -> @define('CONST_Replication_Url', 'http://download.geofabrik.de/south-america/brazil-updates/');
sudo docker run -t -v "${PWD}:/data" osrm/osrm-backend osrm-extract -p /opt/car.lua /data/brazil-latest.osm.pbf 
sudo docker run -t -v "${PWD}:/data" osrm/osrm-backend osrm-partition /data/brazil-latest.osrm
sudo docker run -t -v "${PWD}:/data" osrm/osrm-backend osrm-customize /data/brazil-latest.osrm
sudo docker run -t -i -p 5000:5000 -v "${PWD}:/data" osrm/osrm-backend osrm-routed --algorithm mld /data/brazil-latest.osrm
sudo docker run -p 9966:9966 osrm/osrm-frontend
