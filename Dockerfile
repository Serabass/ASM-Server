ARG FINAL_IMAGE=scratch

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

# Компилируем ассемблер со статической линковкой для scratch и strip для уменьшения размера
RUN nasm -f elf64 server.asm -o server.o && \
    ld -m elf_x86_64 -static -s -o server server.o

RUN ls -lha /build

#####################################################################

# Финальный образ - пустой scratch
FROM ${FINAL_IMAGE}

# Копируем собранный статический бинарник
COPY --from=builder /build/server /server

# Открываем порт
EXPOSE 8080

# Запускаем сервер
CMD ["/server"]

