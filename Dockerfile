FROM mcr.microsoft.com/dotnet/aspnet:3.1.11@sha256:c94e369153b15293486b11c7a2b6f8e3fe27fdc479cd355ba54b9183fdf89aa4 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:3.1.405@sha256:d27da1b416478f572ce3b9ef85b0d8010e203ffca4a10fb769a7a0463c32552e AS build
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
