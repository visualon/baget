FROM mcr.microsoft.com/dotnet/aspnet:3.1.16@sha256:4aa86f9e16fb0220a495190d4125599fb230a93543eb02978590abef2558f3fb AS base
WORKDIR /app
EXPOSE 80

LABEL maintainer="Michael Kriese <michael.kriese@visualon.de>" \
  org.opencontainers.image.authors="Michael Kriese <michael.kriese@visualon.de>" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.source="https://github.com/visualon/baget" \
  org.opencontainers.image.url="https://github.com/visualon/baget"

FROM mcr.microsoft.com/dotnet/sdk:3.1.410@sha256:a7dfb0cfb07a0004304d9d48169c86080bb4fc4fb1d5873e3187accd6e28a37d AS build
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs
WORKDIR /src
COPY /src .
RUN dotnet restore BaGet
RUN dotnet build BaGet -c Release -o /app

FROM build AS publish
RUN dotnet publish BaGet -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "BaGet.dll"]
