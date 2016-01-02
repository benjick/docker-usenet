build:
	docker-compose -f docker-compose.dev.yml build

build-clean:
	docker-compose -f docker-compose.dev.yml build --no-cache

up:
	docker-compose -f docker-compose.dev.yml up

upd:
	docker-compose -f docker-compose.dev.yml up -d

kill:
	docker-compose -f docker-compose.dev.yml kill

clean:
	docker-compose -f docker-compose.dev.yml kill
	docker-compose -f docker-compose.dev.yml rm -f
