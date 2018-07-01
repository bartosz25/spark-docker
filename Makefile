all:
	@echo "Available commands are:"
	@echo "- build_base_image   - builds shared image"
	@echo "- build_master_image - builds master image"
	@echo "- build_slave_image  - builds slave image"

build_base_image:
	docker rmi --force spark_base_image; docker build -f ./Dockerfile . -t spark_base_image

build_master_image:
	docker rmi --force spark_compose_master; docker build -f ./master/Dockerfile . -t spark_compose_master

build_slave_image:
	docker rmi --force spark_compose_slave; docker build -f ./slave/Dockerfile . -t spark_compose_slave
