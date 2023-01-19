#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:2.2 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:2.2 AS build
WORKDIR /src
COPY ["TestApp1.csproj", "."]
RUN dotnet restore "./TestApp1.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "TestApp1.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "TestApp1.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TestApp1.dll"]