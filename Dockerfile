# escape=`
FROM microsoft/windowsservercore:10.0.14393.1770
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

# Wait-Service is a tool from Microsoft for monitoring a Windows Service
COPY Wait-Service.ps1 /

# Install Windows features for IIS
RUN Add-WindowsFeature Web-server, NET-Framework-45-ASPNET, Web-Asp-Net45

RUN Remove-Website 'Default Web Site'

# Set up website: app
COPY build /websites/app
RUN New-Website -Name 'app' -PhysicalPath "C:\websites\app" -Port 80 -Force
EXPOSE 80

CMD /Wait-Service.ps1 -ServiceName W3SVC -AllowServiceRestart
