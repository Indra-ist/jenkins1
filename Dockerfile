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

# Expose port 80 for Azure App Service
EXPOSE 80

# Important: Let app bind to port 80 inside container
ENV ASPNETCORE_URLS=http://+:80

# Start the app
ENTRYPOINT ["dotnet", "jkwebapptest.dll"]
