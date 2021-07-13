FROM mcr.microsoft.com/dotnet/aspnet:3.1.17@sha256:e0499f93c1ad1fc217c9476a6cc36be19fc2c27fcbeb5a24f17854e6d26a8110 AS base
WORKDIR /app
EXPOSE 80

LABEL maintainer="Michael Kriese <michael.kriese@visualon.de>" \
  org.opencontainers.image.authors="Michael Kriese <michael.kriese@visualon.de>" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.source="https://github.com/visualon/baget" \
  org.opencontainers.image.url="https://github.com/visualon/baget"

FROM mcr.microsoft.com/dotnet/sdk:3.1.411@sha256:3ca64d91b3d7ac75cf18d9bf881c05ce1d22ee1740428ac4d09a65fa62b70c46 AS build
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs
WORKDIR /src
COPY /src .
RUN dotnet restore BaGet
RUN dotnet build BaGet -c Release -o /app

FROM build AS publish
RUN dotnet publish BaGet -c Release -o /app

FROM base AS final
LABEL org.opencontainers.image.source="https://github.com/loic-sharma/BaGet"
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "BaGet.dll"]
