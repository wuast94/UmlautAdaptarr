FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

COPY . ./
RUN dotnet restore
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:8.0
LABEL org.opencontainers.image.source="https://github.com/PCJones/UmlautAdaptarr"
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "UmlautAdaptarr.dll"]
