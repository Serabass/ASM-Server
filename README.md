# Веб-сервер на ассемблере для Kubernetes

https://asm.serabass.kz

## Структура проекта

Проект разделён на три варианта сборки, каждый в своей директории:

- **`embedded/`** - HTML встроен в код ассемблера
- **`external/`** - HTML включается через `incbin` при сборке
- **`file/`** - HTML читается с диска во время выполнения

## Размеры образов и бинарников

> **Примечание:** Docker показывает несжатые размеры (реальное использование диска). Веб-интерфейс реестра (http://reg.serabass.kz/) показывает сжатые размеры (для передачи по сети), которые меньше.

### Embedded (HTML встроен в код)

| Base Image | OS | Docker Image (несжатый) | Registry (сжатый) | Binary Size | Описание |
|------------|----|------------------------|-------------------|-------------|----------|
| `scratch` | No OS | 11.2 kB | 4.25 KB | 10.9 KB | Минимальный размер |
| `distroless` | No OS | 2.09 MB | 705.56 KB | 10.9 KB | Google distroless (static) |
| `busybox` | BusyBox | 4.44 MB | 2.18 MB | 10.9 KB | Минимальная база с утилитами |
| `alpine` | Alpine Linux | 8.45 MB | 3.69 MB | 10.9 KB | С базой Alpine |
| `wolfi` | Wolfi | 15.9 MB | 6.42 MB | 10.9 KB | Chainguard Wolfi (security-focused) |
| `slim` | Debian | 80.7 MB | 30 MB | 10.9 KB | Debian slim версия |
| `ubuntu` | Ubuntu | 78.1 MB | 29.18 MB | 10.9 KB | С базой Ubuntu |
| `debian` | Debian | 120 MB | 48.14 MB | 10.9 KB | Полная версия Debian |
| `rockylinux` | Rocky Linux | 196 MB | 68.6 MB | 10.9 KB | RHEL альтернатива |

### External (HTML через `incbin`)

| Base Image | OS | Docker Image (несжатый) | Registry (сжатый) | Binary Size | Описание |
|------------|----|------------------------|-------------------|-------------|----------|
| `scratch` | No OS | 11.4 kB | 4.34 KB | 11.1 KB | Минимальный размер |
| `distroless` | No OS | 2.09 MB | 705.66 KB | 11.1 KB | Google distroless (static) |
| `busybox` | BusyBox | 4.44 MB | 2.18 MB | 11.1 KB | Минимальная база с утилитами |
| `alpine` | Alpine Linux | 8.45 MB | 3.69 MB | 11.1 KB | С базой Alpine |
| `wolfi` | Wolfi | 15.9 MB | 6.42 MB | 11.1 KB | Chainguard Wolfi (security-focused) |
| `slim` | Debian | 80.7 MB | 30 MB | 11.1 KB | Debian slim версия |
| `ubuntu` | Ubuntu | 78.1 MB | 29.18 MB | 11.1 KB | С базой Ubuntu |
| `debian` | Debian | 120 MB | 48.14 MB | 11.1 KB | Полная версия Debian |
| `rockylinux` | Rocky Linux | 196 MB | 68.6 MB | 11.1 KB | RHEL альтернатива |

### File (HTML читается с диска)

| Base Image | OS | Docker Image (несжатый) | Registry (сжатый) | Binary Size | Описание |
|------------|----|------------------------|-------------------|-------------|----------|
| `scratch` | No OS | 11.6 kB | 6.79 KB | 8.5 KB | Минимальный размер |
| `distroless` | No OS | 2.09 MB | 706.3 KB | 8.5 KB | Google distroless (static) |
| `busybox` | BusyBox | 4.44 MB | 2.18 MB | 8.5 KB | Минимальная база с утилитами |
| `alpine` | Alpine Linux | 8.45 MB | 3.69 MB | 8.5 KB | С базой Alpine |
| `wolfi` | Wolfi | 15.9 MB | 6.42 MB | 8.5 KB | Chainguard Wolfi (security-focused) |
| `slim` | Debian | 80.7 MB | 30 MB | 8.5 KB | Debian slim версия |
| `ubuntu` | Ubuntu | 78.1 MB | 29.18 MB | 8.5 KB | С базой Ubuntu |
| `debian` | Debian | 120 MB | 48.14 MB | 8.5 KB | Полная версия Debian |
| `rockylinux` | Rocky Linux | 196 MB | 68.6 MB | 8.5 KB | RHEL альтернатива |

### Детали по вариантам

**Embedded (встроенная страница):**
- HTML встроен в код ассемблера
- Бинарник: 10.9 KB (из которых ~2.5 KB это HTML страница)

**External (через incbin):**
- HTML включается через `incbin` при сборке
- Бинарник: 11.1 KB (из которых 2.7 KB это HTML страница)
- HTML файл: 2.7 KB (2714 bytes)

**File (чтение с диска):**
- HTML читается с диска во время выполнения
- Бинарник: 8.5 KB (HTML читается отдельно)
- HTML файл: 2.9 KB (2871 bytes, отдельный файл в образе)

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

