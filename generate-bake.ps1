# Скрипт для генерации docker-bake.hcl с таргетами через циклы
# Потому что docker-bake.hcl не поддерживает динамическое создание таргетов

$REGISTRY = "reg.serabass.kz"
$VARIANTS = @("embedded", "external", "file")
$BASE_IMAGES = @{
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

$hclContent = @"
variable "REGISTRY" {
  default = "$REGISTRY"
}

variable "VARIANTS" {
  default = [$(($VARIANTS | ForEach-Object { "`"$_`"" }) -join ", ")]
}

variable "BASE_IMAGES" {
  default = {
$(($BASE_IMAGES.GetEnumerator() | ForEach-Object { "    `"$($_.Key)`" = `"$($_.Value)`"" }) -join "`n")
  }
}

function "targets" {
  params = []
  result = flatten([
    for variant in VARIANTS : [
      for name, image in BASE_IMAGES : "`${variant}-`${name}"
    ]
  ])
}

group "default" {
  targets = targets()
}
"@

# Генерируем таргеты через циклы
foreach ($variant in $VARIANTS) {
    foreach ($baseName in $BASE_IMAGES.Keys) {
        $baseImage = $BASE_IMAGES[$baseName]
        $targetName = "$variant-$baseName"
        
        $hclContent += @"

target "$targetName" {
  context = "./$variant"
  dockerfile = "Dockerfile"
  tags = ["`${REGISTRY}/asm-server:$targetName"]
  args = {
    FINAL_IMAGE = BASE_IMAGES["$baseName"]
  }
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  cache-from = ["type=registry,ref=`${REGISTRY}/asmserver:$targetName"]
  cache-to = ["type=inline"]
}
"@
    }
}

# Сохраняем в файл (используем UTF8 без BOM)
[System.IO.File]::WriteAllText("$PWD\docker-bake.hcl", $hclContent, [System.Text.UTF8Encoding]::new($false))

Write-Host "docker-bake.hcl сгенерирован успешно! Таргетов: $(($VARIANTS.Count * $BASE_IMAGES.Count))" -ForegroundColor Green

