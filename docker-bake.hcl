variable "REGISTRY" {
  default = "reg.serabass.kz"
}

group "default" {
  targets = [
    "embedded-alpine",
    "embedded-scratch",
    "external-alpine",
    "external-scratch",
    "file-alpine",
    "file-scratch",
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
