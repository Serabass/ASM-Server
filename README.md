# Веб-сервер на ассемблере для Kubernetes

https://asm.serabass.kz

## Размер образа

## Структура проекта

Проект разделён на три варианта сборки, каждый в своей директории:

- **`embedded/`** - HTML встроен в код ассемблера
- **`external/`** - HTML включается через `incbin` при сборке
- **`file/`** - HTML читается с диска во время выполнения

## Размеры образов

### Вариант с встроенной страницей (`embedded/`)
- **Docker Image:** 11.2kB
- **Binary:** 10.9KB (11152 bytes, из которых ~2.7KB это HTML страница)

### Вариант с внешней страницей через incbin (`external/`)
- **Docker Image:** 11.4kB
- **Binary:** 11.1KB (11360 bytes, из которых 2.7KB это HTML страница)
- **HTML File:** 2.7KB (2714 bytes, включается в бинарник через incbin)

### Вариант с чтением из файла (`file/`)
- **Docker Image:** 11.6kB
- **Binary:** 8.5KB (8704 bytes, HTML читается с диска отдельно)
- **HTML File:** 2.9KB (2871 bytes, отдельный файл)

## Сборка

### Через docker-bake (рекомендуется)
```powershell
# Все варианты
docker buildx bake

# Конкретный вариант
docker buildx bake embedded-scratch
docker buildx bake external-scratch
docker buildx bake file-scratch
```

### Через docker build
```powershell
# Embedded вариант
docker build -t asm-server:embedded ./embedded

# External вариант
docker build -t asm-server:external ./external

# File вариант
docker build -t asm-server:file ./file
```

## Проверка размеров

```powershell
# Размеры образов
docker images | Select-String "asm-server"

# Размеры бинарников
docker build --target builder -t temp ./embedded
docker run --rm temp ls -lh /build/server
```

Сделано с использованием <a href="https://cursor.com">Cursor IDE</a>

