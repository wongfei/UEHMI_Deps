call "_build_config.cmd"

if not exist "%InstallDir%\ggml" (
	call "build_ggml.cmd"
)

set "Name=whispercpp"
set "BuildDir=%DepsDir%\%Name%_build"

if not exist "%DepsDir%\%Name%" (
	git clone --recurse-submodules https://github.com/ggml-org/whisper.cpp.git "%DepsDir%\%Name%"
	git -C "%DepsDir%\%Name%" checkout 40e788a5
	::set /p whisper_hash=<"ggml/scripts/sync-whisper.last"
	::git -C "%DepsDir%\%Name%" checkout %whisper_hash%
)

cmake ^
	-DCMAKE_INSTALL_PREFIX="%InstallDir%\%Name%" ^
	-DCMAKE_PREFIX_PATH="%InstallDir%\ggml" ^
	-DCMAKE_CXX_FLAGS="/I %InstallDirUnix%/ggml/include" ^
	-DBUILD_SHARED_LIBS=ON ^
	-DWHISPER_USE_SYSTEM_GGML=ON ^
	-DWHISPER_BUILD_TESTS=OFF ^
	-DWHISPER_BUILD_EXAMPLES=OFF ^
	-S "%DepsDir%\%Name%" -B "%BuildDir%" -G "%HMI_VS%" -DCMAKE_SYSTEM_VERSION="%HMI_WSDK%"

cmake --build "%BuildDir%" -j --config %HMI_BUILD_CONFIG%
cmake --install "%BuildDir%" --config %HMI_BUILD_CONFIG%

copy /Y "%DepsDir%\%Name%\LICENSE" "%InstallDir%\%Name%\"

::del /s /q "%InstallDir%\%Name%\bin\ggml*.dll"
