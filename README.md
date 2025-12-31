# Веб-сервер на ассемблере для Kubernetes

https://asm.serabass.kz

## Размер образа

### Вариант с встроенной страницей (server.asm)
- **Docker Image:** 10.9kB
- **Binary:** 10.7KB (10928 bytes, из которых 2кб это HTML страница)

### Вариант с внешней страницей через incbin (server-external.asm + page.html)
- **Docker Image:** 11kB
- **Binary:** 10.7KB (10984 bytes, из которых 2.3кб это HTML страница)

### Вариант с чтением из файла (server-file.asm + page-file.html)
- **Docker Image:** 11.8kB
- **Binary:** 8.5KB (8704 bytes, HTML читается с диска отдельно)
- **HTML File:** 3KB (3083 bytes, отдельный файл)

Размер можно проверить командой:
```powershell
docker images asm-web-server:scratch
docker images asm-web-server:external
docker images asm-web-server:file
```

Размер бинарника можно проверить командой:
```powershell
# Встроенный вариант
docker build --target builder -t asm-builder:temp .
docker run --rm asm-builder:temp ls -lh /build/server

# Вариант с внешней страницей через incbin
docker build -f Dockerfile.external --target builder -t asm-external-builder:temp .
docker run --rm asm-external-builder:temp ls -lh /build/server

# Вариант с чтением из файла
docker build -f Dockerfile.file --target builder -t asm-file-builder:temp .
docker run --rm asm-file-builder:temp ls -lh /build/server
```

Сделано с использованием <a href="https://cursor.com">Cursor IDE</a>

