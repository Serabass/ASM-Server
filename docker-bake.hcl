variable "REGISTRY" {
  default = "reg.serabass.kz"
}

# Определяем типы вариантов и базовые образы
variable "VARIANTS" {
  default = ["embedded", "external", "file"]
}

variable "BASE_IMAGES" {
  default = {
    "scratch" = "scratch"
    "alpine" = "alpine:latest"
    "ubuntu" = "ubuntu:latest"
    "debian" = "debian:latest"
    "busybox" = "busybox:latest"
    "slim" = "debian:bullseye-slim"
    "distroless" = "gcr.io/distroless/static:latest"
    "wolfi" = "cgr.dev/chainguard/wolfi-base:latest"
    "rockylinux" = "rockylinux/rockylinux:latest"
  }
}

# Генерируем список всех таргетов
function "targets" {
  params = []
  result = flatten([
    for variant in VARIANTS : [
      for name, image in BASE_IMAGES : "${variant}-${name}"
    ]
  ])
}

group "default" {
  targets = targets()
}

# Функция для генерации конфигурации таргета
function "target_config" {
  params = [variant, base_name, base_image]
  result = {
    context = "./${variant}"
    dockerfile = "Dockerfile"
    tags = ["${REGISTRY}/asm-server:${variant}-${base_name}"]
    args = {
      FINAL_IMAGE = base_image
    }
    platforms = ["linux/amd64"]
    output = ["type=image,push=true"]
    cache-from = ["type=registry,ref=${REGISTRY}/asmserver:${variant}-${base_name}"]
    cache-to = ["type=inline"]
  }
}

# Генерируем все таргеты динамически
# К сожалению, docker-bake.hcl не поддерживает динамическое создание таргетов через циклы,
# поэтому используем функции для генерации конфигурации каждого таргета

# Embedded варианты
target "embedded-scratch" {
  context = "./embedded"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:embedded-scratch"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["scratch"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = ["type=registry,ref=${REGISTRY}/asmserver:embedded-scratch"]
  cache-to = ["type=inline"]
}

target "embedded-alpine" {
  context = "./embedded"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:embedded-alpine"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["alpine"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = ["type=registry,ref=${REGISTRY}/asmserver:embedded-alpine"]
  cache-to = ["type=inline"]
}

target "embedded-ubuntu" {
  context = "./embedded"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:embedded-ubuntu"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["ubuntu"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = ["type=registry,ref=${REGISTRY}/asmserver:embedded-ubuntu"]
  cache-to = ["type=inline"]
}

target "embedded-debian" {
  context = "./embedded"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:embedded-debian"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["debian"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = ["type=registry,ref=${REGISTRY}/asmserver:embedded-debian"]
  cache-to = ["type=inline"]
}

target "embedded-busybox" {
  context = "./embedded"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:embedded-busybox"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["busybox"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = ["type=registry,ref=${REGISTRY}/asmserver:embedded-busybox"]
  cache-to = ["type=inline"]
}

target "embedded-slim" {
  context = "./embedded"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:embedded-slim"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["slim"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = ["type=registry,ref=${REGISTRY}/asmserver:embedded-slim"]
  cache-to = ["type=inline"]
}

target "embedded-distroless" {
  context = "./embedded"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:embedded-distroless"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["distroless"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = ["type=registry,ref=${REGISTRY}/asmserver:embedded-distroless"]
  cache-to = ["type=inline"]
}

target "embedded-wolfi" {
  context = "./embedded"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:embedded-wolfi"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["wolfi"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = ["type=registry,ref=${REGISTRY}/asmserver:embedded-wolfi"]
  cache-to = ["type=inline"]
}

target "embedded-rockylinux" {
  context = "./embedded"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:embedded-rockylinux"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["rockylinux"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = ["type=registry,ref=${REGISTRY}/asmserver:embedded-rockylinux"]
  cache-to = ["type=inline"]
}

# External варианты
target "external-scratch" {
  context = "./external"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:external-scratch"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["scratch"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = ["type=registry,ref=${REGISTRY}/asmserver:external-scratch"]
  cache-to = ["type=inline"]
}

target "external-alpine" {
  context = "./external"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:external-alpine"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["alpine"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = ["type=registry,ref=${REGISTRY}/asmserver:external-alpine"]
  cache-to = ["type=inline"]
}

target "external-ubuntu" {
  context = "./external"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:external-ubuntu"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["ubuntu"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = ["type=registry,ref=${REGISTRY}/asmserver:external-ubuntu"]
  cache-to = ["type=inline"]
}

target "external-debian" {
  context = "./external"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:external-debian"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["debian"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = ["type=registry,ref=${REGISTRY}/asmserver:external-debian"]
  cache-to = ["type=inline"]
}

target "external-busybox" {
  context = "./external"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:external-busybox"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["busybox"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = ["type=registry,ref=${REGISTRY}/asmserver:external-busybox"]
  cache-to = ["type=inline"]
}

target "external-slim" {
  context = "./external"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:external-slim"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["slim"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = ["type=registry,ref=${REGISTRY}/asmserver:external-slim"]
  cache-to = ["type=inline"]
}

target "external-distroless" {
  context = "./external"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:external-distroless"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["distroless"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = ["type=registry,ref=${REGISTRY}/asmserver:external-distroless"]
  cache-to = ["type=inline"]
}

target "external-wolfi" {
  context = "./external"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:external-wolfi"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["wolfi"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = ["type=registry,ref=${REGISTRY}/asmserver:external-wolfi"]
  cache-to = ["type=inline"]
}

target "external-rockylinux" {
  context = "./external"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:external-rockylinux"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["rockylinux"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = ["type=registry,ref=${REGISTRY}/asmserver:external-rockylinux"]
  cache-to = ["type=inline"]
}

# File варианты
target "file-scratch" {
  context = "./file"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:file-scratch"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["scratch"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = ["type=registry,ref=${REGISTRY}/asmserver:file-scratch"]
  cache-to = ["type=inline"]
}

target "file-alpine" {
  context = "./file"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:file-alpine"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["alpine"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = ["type=registry,ref=${REGISTRY}/asmserver:file-alpine"]
  cache-to = ["type=inline"]
}

target "file-ubuntu" {
  context = "./file"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:file-ubuntu"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["ubuntu"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = ["type=registry,ref=${REGISTRY}/asmserver:file-ubuntu"]
  cache-to = ["type=inline"]
}

target "file-debian" {
  context = "./file"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:file-debian"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["debian"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = ["type=registry,ref=${REGISTRY}/asmserver:file-debian"]
  cache-to = ["type=inline"]
}

target "file-busybox" {
  context = "./file"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:file-busybox"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["busybox"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = ["type=registry,ref=${REGISTRY}/asmserver:file-busybox"]
  cache-to = ["type=inline"]
}

target "file-slim" {
  context = "./file"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:file-slim"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["slim"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = ["type=registry,ref=${REGISTRY}/asmserver:file-slim"]
  cache-to = ["type=inline"]
}

target "file-distroless" {
  context = "./file"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:file-distroless"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["distroless"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = ["type=registry,ref=${REGISTRY}/asmserver:file-distroless"]
  cache-to = ["type=inline"]
}

target "file-wolfi" {
  context = "./file"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:file-wolfi"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["wolfi"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = ["type=registry,ref=${REGISTRY}/asmserver:file-wolfi"]
  cache-to = ["type=inline"]
}

target "file-rockylinux" {
  context = "./file"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:file-rockylinux"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["rockylinux"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = ["type=registry,ref=${REGISTRY}/asmserver:file-rockylinux"]
  cache-to = ["type=inline"]
}
