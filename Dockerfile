# syntax=docker/dockerfile:1
# Get base image (Full .Net Core SDK)
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.sln ./
COPY src/Memo.Commands.Api/*.csproj ./Memo.Commands.Api/

WORKDIR /app/Memo.Commands.Api
RUN dotnet restore

# Copy everything else and build
WORKDIR /app
COPY src/Memo.Commands.Api/. ./Memo.Commands.Api/

WORKDIR /app/Memo.Commands.Api
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
EXPOSE 80
COPY --from=build-env /app/Memo.Commands.Api/out .
ENTRYPOINT ["dotnet", "Memo.Commands.Api.dll"]