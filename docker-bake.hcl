variable "REGISTRY" {
  default = "reg.serabass.kz"
}

# variable "VERSION" {
#   default = "latest"
# }

group "default" {
  targets = [
    "server",
  ]
}

target "server" {
  context = "."
  dockerfile = "Dockerfile"
  tags = [
    "${REGISTRY}/asm-server:latest"
  ]
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = [
    "type=registry,ref=${REGISTRY}/asmserver:latest"
  ]
  cache-to = [
    "type=inline"
  ]
}
