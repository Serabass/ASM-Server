variable "REGISTRY" {
  default = "reg.serabass.kz"
}

variable "VARIANTS" {
  default = ["embedded", "external", "file"]
}

variable "BASE_IMAGES" {
  default = {
    "wolfi" = "cgr.dev/chainguard/wolfi-base:latest"
    "debian" = "debian:latest"
    "alpine" = "alpine:latest"
    "busybox" = "busybox:latest"
    "scratch" = "scratch"
    "ubuntu" = "ubuntu:latest"
    "slim" = "debian:bullseye-slim"
    "distroless" = "gcr.io/distroless/static:latest"
    "rockylinux" = "rockylinux/rockylinux:latest"
  }
}

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
target "embedded-wolfi" {
  context = "./embedded"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:embedded-wolfi"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["wolfi"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
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
  cache-to = ["type=inline"]
}
target "embedded-scratch" {
  context = "./embedded"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:embedded-scratch"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["scratch"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
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
  cache-to = ["type=inline"]
}
target "external-scratch" {
  context = "./external"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:external-scratch"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["scratch"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
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
  cache-to = ["type=inline"]
}
target "file-scratch" {
  context = "./file"
  dockerfile = "Dockerfile"
  tags = ["${REGISTRY}/asm-server:file-scratch"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["scratch"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
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
  cache-to = ["type=inline"]
}