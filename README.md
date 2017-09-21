# Usenet in Docker

Create a usenet downloader and torrent node setup easily with the power of Docker. All built on Alpine.

## Todo

* Headphones
* LazyLibrarian
* Media storage/mounting

## Usage

You probably want Docker Compose to boot these containers

## Installation

1. git clone <this repo url>
2. update dns records to include the listed services pointed to the correct ip address 
   [a  hosts.txt example is provided for appending /etc/hosts on _your_ computer instead of the guest vm]
3. execute `docker-compose up`
4. open localhost or a service in a browser


###
| Service Hostname | application |
| --- | --- |
| torrrent.local   | BitTorrent  |
| sonaar.local     | Sonaar      |
| couchpotato.local | couchpotato |
| nzbget.local (default, localhost goes here) | nzbget |

### Example docker-compose.yml

```yml

proxy:
  image: jwilder/nginx-proxy
  container_name: nginx-proxy
  ports:
    - "80:80/tcp"
  environment:
    DEFAULT_HOST: "nzbget.local"
  volumes:
    - /var/run/docker.sock:/tmp/docker.sock:ro

nzbget:
  image: benjick/nzbget
  ports:
    - "6789:6789"
  environment:
    VIRTUAL_PORT: 6789
    VIRTUAL_HOST: "nzbget.local"
  volumes:
    - ./config/nzbget:/volumes/config
    - ./media:/volumes/media

sonarr:
  image: benjick/sonarr
  links:
    - nzbget
  ports:
    - "8989:8989"
  environment:
    VIRTUAL_PORT: 8989
    VIRTUAL_HOST: "sonarr.local"
  volumes:
    - ./config/sonarr:/volumes/config/sonarr

couchpotato:
  image: benjick/couchpotato
  links:
    - nzbget
  ports:
    - "5050:5050"
  environment:
    VIRTUAL_PORT: 5050
    VIRTUAL_HOST: "couchpotato.local"
  volumes:
    - ./config/couchpotato:/root/.couchpotato

transmission:
  image: transmission:latest
  restart: always
  ports:
    - "9091:9091"
    - "51413:51413"
    - "51413:51413/udp"
  environment:
    VIRTUAL_PORT: 9091
    VIRTUAL_HOST: "torrent.local"
  environment:
    - ADMIN_USER=$ADMIN_USER
    - ADMIN_PASS=$ADMIN_SECRET
  volumes:
    - volumes/transmission/downloads:/var/lib/transmission-daemon/downloads
    - volumes/transmission/incomplete:/var/lib/transmission-daemon/incomplete
    - volumes/transmission/resume:/etc/transmission-daemon/resume
    - volumes/transmission/torrents:/etc/transmission-daemon/torrents
```

If you don't need `couchpotato`, just remove it's section from the compose-file. When you point for example sonarr to a downloader (nzbget) you put nzbget.local instead of localhost:6789 or whatever you usually do.

Then `export ADMIN_USER=<insertAdminHere>` and `export ADMIN_SECRET=invalidPassword`. Finally run `docker-compose up -d` to start the containers. To shut them down just do `docker-compose stop` (or `kill` if you're in a hurry).

A folder named `config` will be created and will contain all databases etc for the applications. This is the folder you want to backup to keep your settings etc. It *should* be all you need to backup, settings-wise.

In this example we are creating a folder called `media` (`./media:/volumes/media`) which can be accessed inside the application with `/volumes/media`. If you want more mountpoints you can just do something like this:

```yml
  volumes:
    - ./media:/volumes/media/tv
    - /some/other/dir:/volumes/media/movies
```

and then use `/volumes/media/tv` and `/volumes/media/movies` instead of just `/volumes/media`.

**Note:** If you do this, don't save any files to /volumes/media because that will be inside the container, not on your drive, which means if you somehow destroy the container the data might get lost.
