variable "REGISTRY" {
  default = "reg.serabass.kz"
}

# variable "VERSION" {
#   default = "latest"
# }

group "default" {
  targets = [
    "server-alpine",
    "server-scratch",
    "server-external-alpine",
    "server-external-scratch",
  ]
}

target "server-alpine" {
  context = "."
  dockerfile = "Dockerfile"
  tags = [
    "${REGISTRY}/asm-server:alpine"
  ]
  args = {
    FINAL_IMAGE = "alpine:latest"
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = [
    "type=registry,ref=${REGISTRY}/asmserver:alpine"
  ]
  cache-to = [
    "type=inline"
  ]
}

target "server-scratch" {
  context = "."
  dockerfile = "Dockerfile"
  tags = [
    "${REGISTRY}/asm-server:scratch"
  ]
  args = {
    FINAL_IMAGE = "scratch"
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = [
    "type=registry,ref=${REGISTRY}/asmserver:scratch"
  ]
  cache-to = [
    "type=inline"
  ]
}

target "server-external-alpine" {
  context = "."
  dockerfile = "Dockerfile.external"
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

target "server-external-scratch" {
  context = "."
  dockerfile = "Dockerfile.external"
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
