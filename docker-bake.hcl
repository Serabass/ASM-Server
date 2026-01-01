variable "REGISTRY" {
  default = "reg.serabass.kz"
}

group "default" {
  targets = [
    "embedded-scratch",
    "embedded-alpine",
    "embedded-ubuntu",
    "embedded-debian",
    "embedded-busybox",
    "embedded-slim",

    "external-scratch",
    "external-alpine",
    "external-ubuntu",
    "external-debian",
    "external-busybox",
    "external-slim",

    "file-scratch",
    "file-alpine",
    "file-ubuntu",
    "file-debian",
    "file-busybox",
    "file-slim",
  ]
}

# Embedded вариант (HTML встроен в код)
target "embedded-ubuntu" {
  context = "./embedded"
  dockerfile = "Dockerfile"
  tags = [
    "${REGISTRY}/asm-server:embedded-ubuntu"
  ]
  args = {
    FINAL_IMAGE = "ubuntu:latest"
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = [
    "type=registry,ref=${REGISTRY}/asmserver:embedded-ubuntu"
  ]
  cache-to = [
    "type=inline"
  ]
}

# Embedded вариант (HTML встроен в код)
target "embedded-alpine" {
  context = "./embedded"
  dockerfile = "Dockerfile"
  tags = [
    "${REGISTRY}/asm-server:embedded-alpine"
  ]
  args = {
    FINAL_IMAGE = "alpine:latest"
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = [
    "type=registry,ref=${REGISTRY}/asmserver:embedded-alpine"
  ]
  cache-to = [
    "type=inline"
  ]
}

target "embedded-scratch" {
  context = "./embedded"
  dockerfile = "Dockerfile"
  tags = [
    "${REGISTRY}/asm-server:embedded-scratch"
  ]
  args = {
    FINAL_IMAGE = "scratch"
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = [
    "type=registry,ref=${REGISTRY}/asmserver:embedded-scratch"
  ]
  cache-to = [
    "type=inline"
  ]
}

target "embedded-debian" {
  context = "./embedded"
  dockerfile = "Dockerfile"
  tags = [
    "${REGISTRY}/asm-server:embedded-debian"
  ]
  args = {
    FINAL_IMAGE = "debian:latest"
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = [
    "type=registry,ref=${REGISTRY}/asmserver:embedded-debian"
  ]
  cache-to = [
    "type=inline"
  ]
}

target "embedded-centos" {
  context = "./embedded"
  dockerfile = "Dockerfile"
  tags = [
    "${REGISTRY}/asm-server:embedded-centos"
  ]
  args = {
    FINAL_IMAGE = "centos:latest"
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = [
    "type=registry,ref=${REGISTRY}/asmserver:embedded-centos"
  ]
  cache-to = [
    "type=inline"
  ]
}

target "embedded-busybox" {
  context = "./embedded"
  dockerfile = "Dockerfile"
  tags = [
    "${REGISTRY}/asm-server:embedded-busybox"
  ]
  args = {
    FINAL_IMAGE = "busybox:latest"
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = [
    "type=registry,ref=${REGISTRY}/asmserver:embedded-busybox"
  ]
  cache-to = [
    "type=inline"
  ]
}

target "embedded-slim" {
  context = "./embedded"
  dockerfile = "Dockerfile"
  tags = [
    "${REGISTRY}/asm-server:embedded-slim"
  ]
  args = {
    FINAL_IMAGE = "debian:bullseye-slim"
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = [
    "type=registry,ref=${REGISTRY}/asmserver:embedded-slim"
  ]
  cache-to = [
    "type=inline"
  ]
}

############################################################################################################################

# External вариант (HTML через incbin)
target "external-ubuntu" {
  context = "./external"
  dockerfile = "Dockerfile"
  tags = [
    "${REGISTRY}/asm-server:external-ubuntu"
  ]
  args = {
    FINAL_IMAGE = "ubuntu:latest"
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = [
    "type=registry,ref=${REGISTRY}/asmserver:external-ubuntu"
  ]
  cache-to = [
    "type=inline"
  ]
}

# External вариант (HTML через incbin)
target "external-alpine" {
  context = "./external"
  dockerfile = "Dockerfile"
  tags = [
    "${REGISTRY}/asm-server:external-alpine"
  ]
  args = {
    FINAL_IMAGE = "alpine:latest"
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = [
    "type=registry,ref=${REGISTRY}/asmserver:external-alpine"
  ]
  cache-to = [
    "type=inline"
  ]
}

target "external-scratch" {
  context = "./external"
  dockerfile = "Dockerfile"
  tags = [
    "${REGISTRY}/asm-server:external-scratch"
  ]
  args = {
    FINAL_IMAGE = "scratch"
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = [
    "type=registry,ref=${REGISTRY}/asmserver:external-scratch"
  ]
  cache-to = [
    "type=inline"
  ]
}

target "external-debian" {
  context = "./external"
  dockerfile = "Dockerfile"
  tags = [
    "${REGISTRY}/asm-server:external-debian"
  ]
  args = {
    FINAL_IMAGE = "debian:latest"
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = [
    "type=registry,ref=${REGISTRY}/asmserver:external-debian"
  ]
  cache-to = [
    "type=inline"
  ]
}

target "external-centos" {
  context = "./external"
  dockerfile = "Dockerfile"
  tags = [
    "${REGISTRY}/asm-server:external-centos"
  ]
  args = {
    FINAL_IMAGE = "centos:latest"
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = [
    "type=registry,ref=${REGISTRY}/asmserver:external-centos"
  ]
  cache-to = [
    "type=inline"
  ]
}

target "external-busybox" {
  context = "./external"
  dockerfile = "Dockerfile"
  tags = [
    "${REGISTRY}/asm-server:external-busybox"
  ]
  args = {
    FINAL_IMAGE = "busybox:latest"
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = [
    "type=registry,ref=${REGISTRY}/asmserver:external-busybox"
  ]
  cache-to = [
    "type=inline"
  ]
}

target "external-slim" {
  context = "./external"
  dockerfile = "Dockerfile"
  tags = [
    "${REGISTRY}/asm-server:external-slim"
  ]
  args = {
    FINAL_IMAGE = "debian:bullseye-slim"
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = [
    "type=registry,ref=${REGISTRY}/asmserver:external-slim"
  ]
  cache-to = [
    "type=inline"
  ]
}

############################################################################################################################

# File вариант (HTML читается с диска)
target "file-ubuntu" {
  context = "./file"
  dockerfile = "Dockerfile"
  tags = [
    "${REGISTRY}/asm-server:file-ubuntu"
  ]
  args = {
    FINAL_IMAGE = "ubuntu:latest"
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = [
    "type=registry,ref=${REGISTRY}/asmserver:file-ubuntu"
  ]
  cache-to = [
    "type=inline"
  ]
}

# File вариант (HTML читается с диска)
target "file-alpine" {
  context = "./file"
  dockerfile = "Dockerfile"
  tags = [
    "${REGISTRY}/asm-server:file-alpine"
  ]
  args = {
    FINAL_IMAGE = "alpine:latest"
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = [
    "type=registry,ref=${REGISTRY}/asmserver:file-alpine"
  ]
  cache-to = [
    "type=inline"
  ]
}

target "file-scratch" {
  context = "./file"
  dockerfile = "Dockerfile"
  tags = [
    "${REGISTRY}/asm-server:file-scratch"
  ]
  args = {
    FINAL_IMAGE = "scratch"
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = [
    "type=registry,ref=${REGISTRY}/asmserver:file-scratch"
  ]
  cache-to = [
    "type=inline"
  ]
}

target "file-debian" {
  context = "./file"
  dockerfile = "Dockerfile"
  tags = [
    "${REGISTRY}/asm-server:file-debian"
  ]
  args = {
    FINAL_IMAGE = "debian:latest"
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = [
    "type=registry,ref=${REGISTRY}/asmserver:file-debian"
  ]
  cache-to = [
    "type=inline"
  ]
}

target "file-centos" {
  context = "./file"
  dockerfile = "Dockerfile"
  tags = [
    "${REGISTRY}/asm-server:file-centos"
  ]
  args = {
    FINAL_IMAGE = "centos:latest"
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = [
    "type=registry,ref=${REGISTRY}/asmserver:file-centos"
  ]
  cache-to = [
    "type=inline"
  ]
}

target "file-busybox" {
  context = "./file"
  dockerfile = "Dockerfile"
  tags = [
    "${REGISTRY}/asm-server:file-busybox"
  ]
  args = {
    FINAL_IMAGE = "busybox:latest"
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = [
    "type=registry,ref=${REGISTRY}/asmserver:file-busybox"
  ]
  cache-to = [
    "type=inline"
  ]
}

target "file-slim" {
  context = "./file"
  dockerfile = "Dockerfile"
  tags = [
    "${REGISTRY}/asm-server:file-slim"
  ]
  args = {
    FINAL_IMAGE = "debian:bullseye-slim"
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = [
    "type=registry,ref=${REGISTRY}/asmserver:file-slim"
  ]
  cache-to = [
    "type=inline"
  ]
}
