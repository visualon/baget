FROM mcr.microsoft.com/dotnet/aspnet:3.1.11@sha256:84e21b92bb3f44777308b152253d2667f124c2cc00da693fdcea2e681f0f5265 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:3.1.405@sha256:0fece15a102530aa2dad9d247bc0d05db6790917696377fc56a8465604ef1aff AS build
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
