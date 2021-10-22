FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build

WORKDIR /src

COPY ["src/merchandise-service/MerchandiseService.csproj", "src/merchandise-service/"]
RUN dotnet restore "src/merchandise-service/MerchandiseService.csproj"

COPY . .

WORKDIR "/src/src/merchandise-service"

RUN dotnet build "MerchandiseService.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MerchandiseService.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS runtime

WORKDIR /app

EXPOSE 800
EXPOSE 443

FROM runtime AS final
WORKDIR /app

COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "MerchandiseService.dll"]