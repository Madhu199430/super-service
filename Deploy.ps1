$appName = "super-service"
$dockerImageName = "username/super-service:latest"

cd .\super-service

Write-Host "Running automated tests..."
dotnet test --no-build --verbosity normal
if ($LASTEXITCODE -ne 0) {
    Write-Host "Tests failed. Aborting deployment."
    exit 1
}

Write-Host "Building Docker image..."
docker build -t $dockerImageName -f .\src\SuperService\Dockerfile .

if ($LASTEXITCODE -ne 0) {
    Write-Host "Docker build failed. Aborting deployment."
    exit 1
}

Write-Host "Pushing Docker image to Docker Hub..."
docker login -u "username" -p "password"
docker push $dockerImageName

if ($LASTEXITCODE -ne 0) {
    Write-Host "Docker push failed. Aborting deployment."
    exit 1
}

Write-Host "Running the container locally..."
docker run -d -p 8080:80 --name $appName $dockerImageName

if ($LASTEXITCODE -eq 0) {
    Write-Host "Application is running at http://localhost:8080"
} else {
    Write-Host "Failed to start the container."
    exit 1
}
