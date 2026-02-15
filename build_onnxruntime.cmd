call "_build_config.cmd"

set "Name=onnxruntime"
set "BuildDir=%DepsDir%\%Name%_build"

if not exist "%DepsDir%\%Name%" (
	git clone -b v1.17.1 --recurse-submodules https://github.com/microsoft/onnxruntime.git "%DepsDir%\%Name%"
	git -C "%DepsDir%\%Name%" apply --directory="/" "%DepsDir%\patch_onnxruntime_v1.17.1.diff"
)

mkdir "%BuildDir%"

:: dont use this bloatware
:: https://onnxruntime.ai/docs/build/eps.html
:: https://developer.nvidia.com/cuda-gpus
::set "UseCuda=--use_cuda --cuda_home "c:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v13.0" --cudnn_home "c:\Program Files\NVIDIA\CUDNN\v9.16""
::set "UseCuda=--use_cuda --cuda_home "D:\dev\cuda" --cudnn_home "D:\dev\cudnn""
::set "CudaArch=CMAKE_CUDA_ARCHITECTURES=75;86;89;120"

set "BuildScript=%DepsDir%\%Name%\build.bat"
set "BuildArgs=--build_dir "%BuildDir%" --config %HMI_BUILD_CONFIG% --parallel --build_shared_lib --use_dml %UseCuda% --skip_tests --cmake_generator "%HMI_VS%" --cmake_extra_defines CMAKE_SYSTEM_VERSION=%HMI_WSDK% CMAKE_POLICY_VERSION_MINIMUM=3.5 %CudaArch%"

start "" /wait cmd /c "%BuildScript% %BuildArgs% > %BuildDir%\build.log 2>&1"

cmake --install "%BuildDir%\%HMI_BUILD_CONFIG%" --config %HMI_BUILD_CONFIG% --prefix "%InstallDir%\%Name%"

copy /Y "%DepsDir%\%Name%\LICENSE" "%InstallDir%\%Name%\"

:: FIX CMAKE MESS

robocopy "%InstallDir%\%Name%\include\onnxruntime" "%InstallDir%\%Name%\include" /E /MOVE

rmdir /s /q "%InstallDir%\%Name%\include\onnxruntime"
rmdir /s /q "%InstallDir%\%Name%\bin"

set "SrcDir=%BuildDir%\%HMI_BUILD_CONFIG%\%HMI_BUILD_CONFIG%"
set "DstDir=%InstallDir%\%Name%\lib"

copy /Y "%SrcDir%\onnxruntime.dll" "%DstDir%\"
copy /Y "%SrcDir%\onnxruntime.pdb" "%DstDir%\"
copy /Y "%SrcDir%\onnxruntime.lib" "%DstDir%\"
copy /Y "%SrcDir%\onnxruntime_providers_shared.dll" "%DstDir%\"
copy /Y "%SrcDir%\onnxruntime_providers_shared.pdb" "%DstDir%\"
copy /Y "%SrcDir%\DirectML.dll" "%DstDir%\"
copy /Y "%SrcDir%\DirectML.pdb" "%DstDir%\"
copy /Y "%SrcDir%\DirectML.Debug.dll" "%DstDir%\"
copy /Y "%SrcDir%\DirectML.Debug.pdb" "%DstDir%\"
