FROM mcr.microsoft.com/dotnet/aspnet:3.1.13@sha256:698ecfdae25f923837b947f568168ec3cc2153757420e8fd1abb1e04aaceeeb2 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:3.1.407@sha256:be7831ab89d8b1b2f98ca5a3cfbc566a06158c7ab8897ec2ecd76c2e2afd89fc AS build
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
