FROM mcr.microsoft.com/dotnet/aspnet:3.1.12@sha256:e72353a4a42bff7beb1fa1f4cedf7b417050dbf1abf19fd7c8a7a0eb5d56150a AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:3.1.406@sha256:8e4a55f6349d9f04f1a02f9e1187ea350a3c77d0300624c5f6f70d5152b2abc1 AS build
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
