call "_build_config.cmd"

set "Name=piper"
set "BuildDir=%DepsDir%\%Name%_build"

if not exist "%DepsDir%\%Name%" (
	git clone -b uehmi --recurse-submodules https://github.com/wongfei/piper.git "%DepsDir%\%Name%"
)

set "UseExternOnnx=ON"
::set "OnnxFlags=-DCMAKE_CXX_FLAGS_INIT=-DORT_API_MANUAL_INIT"

if %UseExternOnnx% == ON (
	set "OnnxDir=-DONNXRUNTIME_DIR=%InstallDirUnix%/onnxruntime"
)

set "RunCmake=ON"
if %RunCmake% == ON (
cmake ^
	-DCMAKE_INSTALL_PREFIX="%InstallDir%\%Name%" %OnnxDir% %OnnxFlags% ^
	-DBUILD_SHARED_LIBS=ON ^
	-DBUILD_WRAPPER=ON ^
	-DREFRESH_DEPS=ON ^
	-DCMAKE_VERBOSE_MAKEFILE=OFF ^
	-S "%DepsDir%\%Name%" -B "%BuildDir%" -G "%HMI_VS%" -DCMAKE_SYSTEM_VERSION="%HMI_WSDK%"
)

cmake --build "%BuildDir%" -j --config %HMI_BUILD_CONFIG%
cmake --install "%BuildDir%" --config %HMI_BUILD_CONFIG%

copy /Y "%DepsDir%\%Name%\LICENSE.md" "%InstallDir%\%Name%\LICENSE"

:: FIX CMAKE MESS

del /s /q "%InstallDir%\%Name%\onnxrun*.*"
del /s /q "%InstallDir%\%Name%\DirectML*.*"

set "PiperBin=%BuildDir%\%HMI_BUILD_CONFIG%"
copy /Y "%PiperBin%\piper.dll" "%InstallDir%\%Name%\"
copy /Y "%PiperBin%\piper.pdb" "%InstallDir%\%Name%\"
copy /Y "%PiperBin%\piper.lib" "%InstallDir%\%Name%\"

set "PhonemizeBin=%BuildDir%\p\src\piper_phonemize_external-build\%HMI_BUILD_CONFIG%"
copy /Y "%PhonemizeBin%\piper_phonemize.dll" "%InstallDir%\%Name%\"
copy /Y "%PhonemizeBin%\piper_phonemize.pdb" "%InstallDir%\%Name%\"
copy /Y "%PhonemizeBin%\piper_phonemize.lib" "%InstallDir%\%Name%\"

set "EspeakBin=%BuildDir%\p\src\piper_phonemize_external-build\e\src\espeak_ng_external-build\src\%HMI_BUILD_CONFIG%"
copy /Y "%EspeakBin%\espeak-ng.dll" "%InstallDir%\%Name%\"
copy /Y "%EspeakBin%\espeak-ng.pdb" "%InstallDir%\%Name%\"
copy /Y "%EspeakBin%\espeak-ng.lib" "%InstallDir%\%Name%\"

:: onnxruntime

set "PrivOnnxDir=%InstallDir%\%Name%\onnxruntime"

if %UseExternOnnx% == OFF (
	mkdir "%PrivOnnxDir%\include"
	mkdir "%PrivOnnxDir%\lib"
	copy /Y "%BuildDir%\pi\include\*.h" "%PrivOnnxDir%\include\"
	copy /Y "%BuildDir%\pi\lib\onnx*.lib" "%PrivOnnxDir%\lib\"
	copy /Y "%BuildDir%\pi\lib\onnx*.dll" "%PrivOnnxDir%\lib\"
)
