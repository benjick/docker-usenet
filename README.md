# Usenet in Docker

Create a usenet downloader setup easily with the power of Docker. All built on Alpine.

## Todo

* Headphones
* LazyLibrarian
* Media storage/mounting
* Torrents?

## Usage

You probably want Docker Compose to boot these containers

### Example docker-compose.yml

```yml
nzbget:
  image: benjick/nzbget
  ports:
    - "6789:6789"
  volumes:
    - ./config:/usr/local/etc
    - ./media:/volumes/media

sonarr:
  image: benjick/sonarr
  links:
    - nzbget
  ports:
    - "8989:8989"
  volumes:
    - ./config/sonarr:/volumes/config/sonarr

couchpotato:
  image: benjick/couchpotato
  links:
    - nzbget
  ports:
    - "5050:5050"
  volumes:
    - ./config/couchpotato:/root/.couchpotato
```

If you don't need `couchpotato`, just remove it's section from the compose-file. When you point for example sonarr to a downloader (nzbget) you put nzbget:6789 instead of localhost:6789 or whatever you usually do.

Then just run `docker-compose up -d` to start the containers. To shut them down just do `docker-compose stop` (or `kill` if you're in a hurry).

A folder named `config` will be created and will contain all databases etc for the applications. This is the folder you want to backup to keep your settings etc. It *should* be all you need to backup, settings-wise.

In this example we are creating a folder called `media` (`./media:/volumes/media`) which can be accessed inside the application with `/volumes/media`. If you want more mountpoints you can just do something like this:

```yml
  volumes:
    - ./media:/volumes/media/tv
    - /some/other/dir:/volumes/media/movies
```

and then use `/volumes/media/tv` and `/volumes/media/movies` instead of just `/volumes/media`.

**Note:** If you do this, don't save any files to /volumes/media because that will be inside the container, not on your drive, which means if you somehow destroy the container the data might get lost.
