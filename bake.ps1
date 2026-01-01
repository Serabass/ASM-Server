$startTime = Get-Date

# Собираем образы локально
docker  `
  buildx bake `
  --allow security.insecure `
  --file docker-bake.hcl `
  --load

# Пушим образы в registry (если сборка успешна)
Write-Output "Pushing images to registry..."
docker push reg.serabass.kz/asm-server:latest

$endTime = Get-Date
$executionTime = $endTime - $startTime

Write-Output ("Elapsed: {0:hh\:mm\:ss\.fff}" -f [TimeSpan]::FromSeconds($executionTime.TotalSeconds))

kubectl rollout restart deployment asm -n asm 2>&1 | Out-Null
