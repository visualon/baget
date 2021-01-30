FROM mcr.microsoft.com/dotnet/aspnet:3.1.11@sha256:4cd975f496e3ab92bf5ce8a73a382f0ad16d72b570b44a37b5c16e1af9e3890e AS base
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
