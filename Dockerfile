FROM microsoft/iis
MAINTAINER florent.appointaire@gmail.com
RUN powershell -command \
  Install-WindowsFeature Web-CGI; \
  New-Item -Path C:\Temp -ItemType Directory; \
  wget -Uri http://windows.php.net/downloads/releases/php-7.0.7-nts-Win32-VC14-x64.zip -OutFile C:\temp\php.zip; \
  Expand-Archive -Path C:\temp\php.zip -DestinationPath C:\php; \
  wget -Uri https://raw.githubusercontent.com/Flodu31/Nginx_Wordpress_WindowsServer/master/php.ini -OutFile C:\php\php.ini; \
  Remove-Item -Path C:\temp\php.zip; \
  wget -Uri https://wordpress.org/latest.zip -OutFile C:\temp\latest.zip; \
  Expand-Archive -Path C:\temp\latest.zip -DestinationPath C:\inetpub\wwwroot; \
  Remove-Item -Path C:\temp\latest.zip; \
  wget -Uri https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x64.exe -OutFile C:\Temp\vcredist_x64.exe; \
  C:\Temp\vcredist_x64.exe /quiet /norestart
CMD C:\Windows\System32\InetSrv\AppCmd.exe set config /section:system.webServer/fastCGI /+[fullPath='c:\php\php-cgi.exe']
CMD C:\Windows\System32\InetSrv\AppCmd.exe set config /section:system.webServer/handlers /+[name='PHP_via_FastCGI',path='*.php',verb='*',modules='FastCgiModule',scriptProcessor='c:\php\php-cgi.exe',resourceType='Either']
CMD C:\Windows\System32\InetSrv\AppCmd.exe set config -section:system.webServer/defaultDocument /+"files.[value='index.php']" /commit:apphost
CMD C:\\Windows\\System32\\icacls.exe C:\\inetpub\\wwwroot\\wordpress /grant IUSR:(OI)(CI)(M)
CMD iisreset
EXPOSE 80