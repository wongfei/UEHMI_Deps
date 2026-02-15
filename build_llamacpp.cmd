call "_build_config.cmd"

if not exist "%InstallDir%\ggml" (
	call "build_ggml.cmd"
)

set "Name=llamacpp"
set "BuildDir=%DepsDir%\%Name%_build"

if not exist "%DepsDir%\%Name%" (
	git clone --recurse-submodules https://github.com/ggml-org/llama.cpp.git "%DepsDir%\%Name%"
	git -C "%DepsDir%\%Name%" checkout 7aaeedc09
	::set /p llama_hash=<"ggml/scripts/sync-llama.last"
	::git -C "%DepsDir%\%Name%" checkout %llama_hash%
)

cmake ^
	-DCMAKE_INSTALL_PREFIX="%InstallDir%\%Name%" ^
	-DCMAKE_PREFIX_PATH="%InstallDir%\ggml" ^
	-DCMAKE_CXX_FLAGS="/I %InstallDirUnix%/ggml/include" ^
	-DBUILD_SHARED_LIBS=ON ^
	-DLLAMA_USE_SYSTEM_GGML=ON ^
	-DLLAMA_BUILD_TESTS=OFF ^
	-DLLAMA_BUILD_EXAMPLES=OFF ^
	-DLLAMA_BUILD_SERVER=OFF ^
	-DLLAMA_BUILD_TOOLS=OFF ^
	-DLLAMA_TOOLS_INSTALL=OFF ^
	-DLLAMA_CURL=OFF ^
	-S "%DepsDir%\%Name%" -B "%BuildDir%" -G "%HMI_VS%" -DCMAKE_SYSTEM_VERSION="%HMI_WSDK%"

cmake --build "%BuildDir%" -j --config %HMI_BUILD_CONFIG%
cmake --install "%BuildDir%" --config %HMI_BUILD_CONFIG%

copy /Y "%DepsDir%\%Name%\LICENSE" "%InstallDir%\%Name%\"

::del /s /q "%InstallDir%\%Name%\bin\ggml*.dll"
