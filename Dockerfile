# Мультистейдж сборка для минимального образа
FROM alpine:latest AS base

# Устанавливаем необходимые инструменты для сборки
RUN apk add --no-cache \
    nasm \
    gcc \
    musl-dev \
    binutils

#####################################################################

FROM base AS builder

# Копируем исходный код
WORKDIR /build
COPY server.asm .

# Компилируем ассемблер
RUN nasm -f elf64 server.asm -o server.o && \
    ld -m elf_x86_64 -o server server.o

#####################################################################

# Финальный образ
FROM alpine:latest

# На Alpine уже есть musl libc, ничего дополнительного не нужно
WORKDIR /app

# Копируем собранный бинарник
COPY --from=builder /build/server .

# Открываем порт
EXPOSE 8080

# Запускаем сервер
CMD ["./server"]

