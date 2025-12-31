# Веб-сервер на ассемблере для Kubernetes

https://asm.serabass.kz

## Размер образа

- **Docker Image:** 11.7kB
- **Binary:** 11.4KB (11664 bytes, из которых 2кб это HTML страница)

Размер можно проверить командой:
```powershell
docker images asm-web-server:scratch
docker images asm-web-server:alpine
```

Размер бинарника можно проверить командой:
```powershell
docker build --target builder -t asm-builder:temp .
docker run --rm asm-builder:temp ls -lh /build/server
```

Сделано с использованием <a href="https://cursor.com">Cursor IDE</a>

