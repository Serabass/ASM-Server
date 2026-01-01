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

| Base Image | Docker Image (несжатый) | Registry (сжатый) | Binary Size | Описание |
|------------|------------------------|-------------------|-------------|----------|
| `scratch` | 11.2 kB | 1.78 KB | 10.9 KB | Минимальный размер |
| `busybox` | 4.44 MB | ~2 MB* | 10.9 KB | Минимальная база с утилитами |
| `alpine` | 8.45 MB | 3.68 MB | 10.9 KB | С базой Alpine |
| `slim` | 80.7 MB | ~30 MB* | 10.9 KB | Debian slim версия |
| `ubuntu` | 78.1 MB | 29.18 MB | 10.9 KB | С базой Ubuntu |
| `debian` | 120 MB | ~45 MB* | 10.9 KB | Полная версия Debian |

### External (HTML через `incbin`)

| Base Image | Docker Image (несжатый) | Registry (сжатый) | Binary Size | Описание |
|------------|------------------------|-------------------|-------------|----------|
| `scratch` | 11.4 kB | 1.81 KB | 11.1 KB | Минимальный размер |
| `busybox` | 4.44 MB | ~2 MB* | 11.1 KB | Минимальная база с утилитами |
| `alpine` | 8.45 MB | 3.68 MB | 11.1 KB | С базой Alpine |
| `slim` | 80.7 MB | ~30 MB* | 11.1 KB | Debian slim версия |
| `ubuntu` | 78.1 MB | 29.18 MB | 11.1 KB | С базой Ubuntu |
| `debian` | 120 MB | ~45 MB* | 11.1 KB | Полная версия Debian |

### File (HTML читается с диска)

| Base Image | Docker Image (несжатый) | Registry (сжатый) | Binary Size | Описание |
|------------|------------------------|-------------------|-------------|----------|
| `scratch` | 11.6 kB | 1.84 KB | 8.5 KB | Минимальный размер |
| `busybox` | 4.44 MB | ~2 MB* | 8.5 KB | Минимальная база с утилитами |
| `alpine` | 8.45 MB | 3.68 MB | 8.5 KB | С базой Alpine |
| `slim` | 80.7 MB | ~30 MB* | 8.5 KB | Debian slim версия |
| `ubuntu` | 78.1 MB | 29.18 MB | 8.5 KB | С базой Ubuntu |
| `debian` | 120 MB | ~45 MB* | 8.5 KB | Полная версия Debian |

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

