FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY ["k8s-demo/k8s-demo.csproj", "k8s-demo/"]
RUN dotnet restore "k8s-demo/k8s-demo.csproj"
COPY . .
WORKDIR "/src/k8s-demo"
RUN dotnet build "k8s-demo.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "k8s-demo.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "k8s-demo.dll"]