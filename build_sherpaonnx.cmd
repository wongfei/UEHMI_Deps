call "_build_config.cmd"

set "Name=sherpaonnx"
set "BuildDir=%DepsDir%\%Name%_build"

if not exist "%DepsDir%\%Name%" (
	git clone -b v1.12.18 --recurse-submodules https://github.com/k2-fsa/sherpa-onnx.git "%DepsDir%\%Name%"
	git -C "%DepsDir%\%Name%" apply --directory="/" "%DepsDir%\patch_sherpaonnx_v1.12.18.diff"
)

set "UseExternOnnx=ON"
::set "OnnxFlags=-DCMAKE_CXX_FLAGS_INIT=-DORT_API_MANUAL_INIT"

if %UseExternOnnx% == ON (
	set "SHERPA_ONNXRUNTIME_INCLUDE_DIR=%InstallDirUnix%/onnxruntime/include"
	set "SHERPA_ONNXRUNTIME_LIB_DIR=%InstallDirUnix%/onnxruntime/lib"
)

:: https://k2-fsa.github.io/sherpa/onnx/install/windows.html
set "RunCmake=ON"
if %RunCmake% == ON (
cmake ^
	-DCMAKE_INSTALL_PREFIX="%InstallDir%\%Name%" ^
	-DSHERPA_ONNX_USE_PRE_INSTALLED_ONNXRUNTIME_IF_AVAILABLE=%UseExternOnnx% %OnnxFlags% ^
	-DBUILD_SHARED_LIBS=ON ^
	-DSHERPA_ONNX_ENABLE_C_API=ON ^
	-DSHERPA_ONNX_ENABLE_GPU=OFF ^
	-DSHERPA_ONNX_ENABLE_DIRECTML=ON ^
	-DSHERPA_ONNX_ENABLE_BINARY=OFF ^
	-DSHERPA_ONNX_BUILD_C_API_EXAMPLES=OFF ^
	-S "%DepsDir%\%Name%" -B "%BuildDir%" -G "%HMI_VS%" -DCMAKE_SYSTEM_VERSION="%HMI_WSDK%"
)

cmake --build "%BuildDir%" -j --config %HMI_BUILD_CONFIG%
cmake --install "%BuildDir%" --config %HMI_BUILD_CONFIG%

copy /Y "%DepsDir%\%Name%\LICENSE" "%InstallDir%\%Name%\"

call "%DepsDir%\gen_sherpaonnx_api.cmd"

:: FIX CMAKE MESS

rmdir /s /q "%InstallDir%\%Name%\bin"
rmdir /s /q "%InstallDir%\%Name%\share"

del /s /q "%InstallDir%\%Name%\lib\onnxrun*.*"
del /s /q "%InstallDir%\%Name%\lib\DirectML*.*"

:: onnxruntime

set "PrivOnnxDir=%InstallDir%\%Name%\onnxruntime"

if %UseExternOnnx% == OFF (
	mkdir "%PrivOnnxDir%\include"
	mkdir "%PrivOnnxDir%\lib"
	copy /Y "%BuildDir%\_deps\onnxruntime-src\build\native\include\*.h" "%PrivOnnxDir%\include\"
	copy /Y "%BuildDir%\_deps\onnxruntime-src\runtimes\win-x64\native\*.lib" "%PrivOnnxDir%\lib\"
	copy /Y "%BuildDir%\_deps\onnxruntime-src\runtimes\win-x64\native\*.dll" "%PrivOnnxDir%\lib\"
)
