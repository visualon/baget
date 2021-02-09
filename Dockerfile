FROM mcr.microsoft.com/dotnet/aspnet:3.1.12@sha256:f88b667f54bb2a98dc7b2ae252aa1eac31322ee80e9820f46f7bea7f3b2e38b3 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:3.1.406@sha256:900486d6287b574931ec580fcaa0c97e8d5e3c7659ef4a7c81e3d71410d02827 AS build
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
