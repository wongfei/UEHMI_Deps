call "_build_config.cmd"

set "Name=cld2"
set "BuildDir=%DepsDir%\%Name%_build"

if not exist "%DepsDir%\%Name%" (
	git clone --recurse-submodules https://github.com/wongfei/cld2.git "%DepsDir%\%Name%"
)

cmake ^
	-DCMAKE_INSTALL_PREFIX="%InstallDir%\%Name%" ^
	-DBUILD_SHARED_LIBS=ON ^
	-S "%DepsDir%\%Name%" -B "%BuildDir%" -G "%HMI_VS%" -DCMAKE_SYSTEM_VERSION="%HMI_WSDK%"

cmake --build "%BuildDir%" -j --config %HMI_BUILD_CONFIG%
cmake --install "%BuildDir%" --config %HMI_BUILD_CONFIG%

copy /Y "%DepsDir%\%Name%\LICENSE" "%InstallDir%\%Name%\"
