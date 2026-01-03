param(
    [switch]$Sequential = $false,
    [switch]$Verbose = $false
)

$startTime = Get-Date

if ($Sequential) {
    # Последовательная сборка для избежания проблем с registry
    Write-Host "Собираю образы последовательно (медленнее, но надежнее)..." -ForegroundColor Yellow
    
    $targets = docker buildx bake --file docker-bake.hcl --print 2>&1 | Select-String -Pattern 'target "' | ForEach-Object { 
        if ($_ -match 'target "([^"]+)"') { $matches[1] }
    }
    
    $failed = @()
    foreach ($target in $targets) {
        Write-Host "Собираю $target..." -ForegroundColor Cyan
        if ($Verbose) {
            docker buildx bake --allow security.insecure --file docker-bake.hcl $target
        } else {
            docker buildx bake --allow security.insecure --file docker-bake.hcl $target 2>&1 | Out-Null
        }
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Ошибка при сборке $target" -ForegroundColor Red
            $failed += $target
        }
    }
    
    if ($failed.Count -gt 0) {
        Write-Host "Не удалось собрать следующие таргеты: $($failed -join ', ')" -ForegroundColor Red
        exit 1
    }
} else {
    # Параллельная сборка (быстрее, но могут быть проблемы с registry)
    Write-Host "Собираю образы параллельно..." -ForegroundColor Yellow
    
    if ($Verbose) {
        docker buildx bake --allow security.insecure --file docker-bake.hcl
    } else {
        docker buildx bake --allow security.insecure --file docker-bake.hcl 2>&1 | Out-Null
    }
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Ошибка при сборке! Попробуй с флагом -Sequential для последовательной сборки" -ForegroundColor Red
        exit $LASTEXITCODE
    }
}

$endTime = Get-Date
$executionTime = $endTime - $startTime

Write-Host "Сборка завершена успешно! Время: $($executionTime.TotalSeconds) сек" -ForegroundColor Green

kubectl rollout restart deployment asm -n asm 2>&1 | Out-Null
