
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env
WORKDIR /app

COPY SuperService/src/* ./SuperService/src/
RUN dotnet restore

COPY . ./
WORKDIR /app/SuperService/src

RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
COPY --from=build-env /app/SuperService/src/out .

EXPOSE 80

ENTRYPOINT ["dotnet", "SuperService.dll"]
