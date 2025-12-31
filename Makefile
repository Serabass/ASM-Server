.PHONY: build run docker-build docker-run k8s-deploy k8s-delete clean

# Локальная сборка (для тестирования на Linux)
build:
	nasm -f elf64 server.asm -o server.o
	ld -m elf_x86_64 -o server server.o

# Запуск локально (только на Linux)
run: build
	./server

# Сборка Docker образа
docker-build:
	docker build -t asm-web-server:latest .

# Запуск Docker контейнера
docker-run: docker-build
	docker run -p 8080:8080 --rm asm-web-server:latest

# Деплой в Kubernetes
k8s-deploy: docker-build
	kubectl apply -f k8s-deployment.yaml

# Удаление из Kubernetes
k8s-delete:
	kubectl delete -f k8s-deployment.yaml

# Очистка
clean:
	rm -f server.o server

