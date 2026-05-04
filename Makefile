.PHONY: up down restart logs ps shell clean

up:
	docker-compose up -d

down:
	docker-compose down

restart:
	docker-compose restart

logs:
	docker-compose logs -f

ps:
	docker-compose ps

shell jellyfin:
	docker exec -it jellyfin /bin/bash

shell jackett:
	docker exec -it jackett /bin/bash

shell aria2:
	docker exec -it aria2 /bin/bash

clean:
	docker-compose down -v
