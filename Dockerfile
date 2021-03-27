FROM mcr.microsoft.com/dotnet/aspnet:3.1.13@sha256:d05df4bf323b58e06c3f2df87fb4b17fab8c32e846ea41431931e870d3080090 AS base
WORKDIR /app
EXPOSE 80

LABEL maintainer="Michael Kriese <michael.kriese@visualon.de>" \
  org.opencontainers.image.authors="Michael Kriese <michael.kriese@visualon.de>" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.source="https://github.com/visualon/baget" \
  org.opencontainers.image.url="https://github.com/visualon/baget"

FROM mcr.microsoft.com/dotnet/sdk:3.1.407@sha256:b8452499123cd8b38951869b5b71f44beaf9f8b9c3046fc2a19e4cdb1f908bb2 AS build
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
