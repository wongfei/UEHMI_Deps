call "_build_config.cmd"

set "Name=ggml"
set "BuildDir=%DepsDir%\%Name%_build"

if not exist "%DepsDir%\%Name%" (
	git clone --recurse-submodules https://github.com/ggml-org/ggml.git "%DepsDir%\%Name%"
	git -C "%DepsDir%\%Name%" checkout 55bc9320
)

cmake ^
	-DCMAKE_INSTALL_PREFIX="%InstallDir%\%Name%" ^
	-DBUILD_SHARED_LIBS=ON ^
	-DGGML_BACKEND_DL=ON ^
	-DGGML_CPU_ALL_VARIANTS=ON ^
	-DGGML_NATIVE=OFF ^
	-DGGML_CUDA=OFF ^
	-DGGML_VULKAN=ON ^
	-DGGML_BUILD_TESTS=OFF ^
	-DGGML_BUILD_EXAMPLES=OFF ^
	-S "%DepsDir%\%Name%" -B "%BuildDir%" -G "%HMI_VS%" -DCMAKE_SYSTEM_VERSION="%HMI_WSDK%"

cmake --build "%BuildDir%" -j --config %HMI_BUILD_CONFIG%
cmake --install "%BuildDir%" --config %HMI_BUILD_CONFIG%

copy /Y "%DepsDir%\%Name%\LICENSE" "%InstallDir%\%Name%\"
