# Веб-сервер на ассемблере для Kubernetes

https://asm.serabass.kz

## Структура проекта

Проект разделён на три варианта сборки, каждый в своей директории:

- **`embedded/`** - HTML встроен в код ассемблера
- **`external/`** - HTML включается через `incbin` при сборке
- **`file/`** - HTML читается с диска во время выполнения

## Размеры образов и бинарников

| Вариант | Base Image | Docker Image | Binary Size | Описание |
|---------|------------|--------------|-------------|----------|
| **embedded** | `scratch` | 11.2 kB | 10.9 KB | HTML встроен в код, минимальный размер |
| **embedded** | `alpine` | 8.45 MB | 10.9 KB | HTML встроен в код, с базой Alpine |
| **embedded** | `ubuntu` | 78.1 MB | 10.9 KB | HTML встроен в код, с базой Ubuntu |
| **external** | `scratch` | 11.4 kB | 11.1 KB | HTML через `incbin`, минимальный размер |
| **external** | `alpine` | 8.45 MB | 11.1 KB | HTML через `incbin`, с базой Alpine |
| **external** | `ubuntu` | 78.1 MB | 11.1 KB | HTML через `incbin`, с базой Ubuntu |
| **file** | `scratch` | 11.6 kB | 8.5 KB | HTML читается с диска, минимальный размер |
| **file** | `alpine` | 8.45 MB | 8.5 KB | HTML читается с диска, с базой Alpine |
| **file** | `ubuntu` | 78.1 MB | 8.5 KB | HTML читается с диска, с базой Ubuntu |

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

