FROM mcr.microsoft.com/dotnet/aspnet:3.1.17@sha256:f74bf9c3941cf18e9b8be48f44dd504b3a97c58b4880ec62456caa8a933ed93c AS base
WORKDIR /app
EXPOSE 80

LABEL maintainer="Michael Kriese <michael.kriese@visualon.de>" \
  org.opencontainers.image.authors="Michael Kriese <michael.kriese@visualon.de>" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.source="https://github.com/visualon/baget" \
  org.opencontainers.image.url="https://github.com/visualon/baget"

FROM mcr.microsoft.com/dotnet/sdk:3.1.411@sha256:dd46d680746b1f77f24c623b45c577ce88f1c2d008bd6bcffa2d94be771d0aee AS build
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
