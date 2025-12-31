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
