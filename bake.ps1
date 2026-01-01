$startTime = Get-Date

# Собираем и пушим образы (без логов)
# Образы автоматически пушатся благодаря output = ["type=image,push=true"] в конфиге
docker buildx bake --allow security.insecure --file docker-bake.hcl 2>&1 | Out-Null

if ($LASTEXITCODE -ne 0) {
    Write-Host "Ошибка при сборке!" -ForegroundColor Red
    exit $LASTEXITCODE
}

$endTime = Get-Date
$executionTime = $endTime - $startTime

Write-Host "Сборка завершена успешно! Время: $($executionTime.ToString('hh\:mm\:ss\.fff'))" -ForegroundColor Green

kubectl rollout restart deployment asm -n asm 2>&1 | Out-Null
