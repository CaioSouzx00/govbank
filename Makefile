up:
	docker compose -f docker/postgres/docker-compose.yml up -d

down:
	docker compose -f docker/postgres/docker-compose.yml down

status:
	docker ps

logs:
	docker logs govbank-postgres

core:
	cobc -x core/main.cob -o core/govbank-core && ./core/govbank-core

api:
	cd api && mvn spring-boot:run
