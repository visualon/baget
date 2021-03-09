FROM mcr.microsoft.com/dotnet/aspnet:3.1.13@sha256:f896f72fe91d31db34d50f6c692ebe956e11719f4621933d909193a2bfd6c7aa AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:3.1.407@sha256:f4b2a826a7da3afcffff2be8dbe68519ff9ff097f8ece52de00ec52c059cd3e5 AS build
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
