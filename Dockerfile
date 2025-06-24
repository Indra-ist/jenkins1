# Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /app

# Copy project files and restore dependencies
COPY jkwebapptest.csproj ./
RUN dotnet restore

# Copy the entire project and build it
COPY . ./
RUN dotnet publish -c Release -o out

# Use a smaller runtime image for the final container
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

WORKDIR /app
COPY --from=build /app/out .

# Azure App Service expects port 8080 (not 80)
EXPOSE 8080

# Critical: Set ASPNETCORE_URLS to port 8080 for Azure App Service
ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production

# Start the app
ENTRYPOINT ["dotnet", "jkwebapptest.dll"]