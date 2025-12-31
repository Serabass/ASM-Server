# PowerShell скрипт для сборки и деплоя
# Потому что нахуй bash на Windows

param(
  [Parameter(Mandatory = $false)]
  [ValidateSet("build", "docker-build", "docker-run", "k8s-deploy", "k8s-delete", "clean")]
  [string]$Action = "docker-build"
)

function Build-Docker {
  Write-Host "Собираю Docker образ, подожди блядь..." -ForegroundColor Yellow
  docker build -t asm-web-server:latest .
  if ($LASTEXITCODE -eq 0) {
    Write-Host "Образ собран успешно!" -ForegroundColor Green
  }
  else {
    Write-Host "Ебать, ошибка при сборке!" -ForegroundColor Red
    exit 1
  }
}

function Run-Docker {
  Write-Host "Запускаю контейнер на порту 8080..." -ForegroundColor Yellow
  docker run -p 8080:8080 --rm asm-web-server:latest
}

function Deploy-K8s {
  Write-Host "Деплою в Kubernetes, не мешай..." -ForegroundColor Yellow
  kubectl apply -f k8s-deployment.yaml
  if ($LASTEXITCODE -eq 0) {
    Write-Host "Деплой завершён! Проверь: kubectl get pods -l app=asm-web-server" -ForegroundColor Green
  }
  else {
    Write-Host "Бля, ошибка при деплое!" -ForegroundColor Red
    exit 1
  }
}

function Remove-K8s {
  Write-Host "Удаляю из Kubernetes..." -ForegroundColor Yellow
  kubectl delete -f k8s-deployment.yaml
}

function Clean-Build {
  Write-Host "Чищу артефакты сборки..." -ForegroundColor Yellow
  Remove-Item -ErrorAction SilentlyContinue server.o, server
  Write-Host "Готово!" -ForegroundColor Green
}

switch ($Action) {
  "build" { 
    Write-Host "Локальная сборка работает только на Linux, иди нахуй" -ForegroundColor Red
  }
  "docker-build" { Build-Docker }
  "docker-run" { 
    Build-Docker
    Run-Docker 
  }
  "k8s-deploy" { 
    Build-Docker
    Deploy-K8s 
  }
  "k8s-delete" { Remove-K8s }
  "clean" { Clean-Build }
  default { 
    Write-Host "Неизвестное действие, долбоёб. Используй: build, docker-build, docker-run, k8s-deploy, k8s-delete, clean" -ForegroundColor Red
  }
}

