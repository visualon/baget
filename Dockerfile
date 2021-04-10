FROM mcr.microsoft.com/dotnet/aspnet:3.1.13@sha256:3d4839108149ccbf8be1b4e140a8ce5fbd917846be28071e820306b14b3ae588 AS base
WORKDIR /app
EXPOSE 80

LABEL maintainer="Michael Kriese <michael.kriese@visualon.de>" \
  org.opencontainers.image.authors="Michael Kriese <michael.kriese@visualon.de>" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.source="https://github.com/visualon/baget" \
  org.opencontainers.image.url="https://github.com/visualon/baget"

FROM mcr.microsoft.com/dotnet/sdk:3.1.407@sha256:ba23df234a2a1fac99d39caf09c5975ca82fa01c8a69d4cb8ab7f5758318f7f3 AS build
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
