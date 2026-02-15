SET "DepsDir=%~dp0"
IF %DepsDir:~-1%==\ SET "DepsDir=%DepsDir:~0,-1%"
SET "DepsDirUnix=%DepsDir:\=/%"

::SET "InstallDir=d:\UE\HMIDemo\Plugins\HMI\Source\ThirdParty"
SET "InstallDir=%DepsDir%\_prefix"
SET "InstallDirUnix=%InstallDir:\=/%"

SET "HMI_VS=Visual Studio 17 2022"
SET "HMI_WSDK=10.0.19041.0"
SET "HMI_BUILD_CONFIG=RelWithDebInfo"
