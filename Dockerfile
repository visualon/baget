FROM mcr.microsoft.com/dotnet/aspnet:3.1.11@sha256:5303040cca4c5287419e7036d79acdf3688e7cb98fda17629188e087fc991748 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:3.1.405@sha256:f7bc4a555fef18101b64bc7b954738489349d53655731ef8254f4d4619a9230c AS build
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
