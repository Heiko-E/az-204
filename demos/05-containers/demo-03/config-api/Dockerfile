# Build Image
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build
WORKDIR /build

COPY . .
RUN dotnet restore "config-api.csproj"
RUN dotnet publish -c Release -o /app

# Runtime Image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app .
ENTRYPOINT ["dotnet", "config-api.dll"]

# Build Image
# docker build --rm -f dockerfile -t config-api .

# Run Image without env vars
# docker run -it --rm -p 5051:8080 config-api

# Browse using: 
# http://localhost:5051/

# Publish Image to dockerhub
# docker tag config-api alexander-kastil/config-api
# docker push alexander-kastil/config-api