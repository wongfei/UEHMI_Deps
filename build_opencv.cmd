call "_build_config.cmd"

set "Name=opencv"
set "BuildDir=%DepsDir%\%Name%_build"

if not exist "%DepsDir%\%Name%" (
	git clone -b 4.12.0 --recurse-submodules https://github.com/opencv/opencv.git "%DepsDir%\%Name%"
)

:: Engine\Plugins\Runtime\OpenCV\Source\ThirdParty\OpenCV\build.bat
cmake ^
	-DCMAKE_INSTALL_PREFIX="%InstallDir%\%Name%" ^
	-DOPENCV_EXTRA_MODULES_PATH="%DepsDir%\opencv_unreal" ^
	-DOPENCV_VERSION="hmi" ^
	-DOPENCV_DLLVERSION="hmi" ^
	-DBUILD_SHARED_LIBS=ON ^
	-DBUILD_WITH_STATIC_CRT=OFF ^
	-DBUILD_WITH_DEBUG_INFO=OFF ^
	-DENABLE_INSTRUMENTATION=OFF ^
	-DCV_TRACE=OFF ^
	-DWITH_ITT=OFF ^
	-DWITH_OPENCL=OFF ^
	-DWITH_WEBP=OFF ^
	-DWITH_OPENEXR=OFF ^
	-DWITH_IMGCODEC_GIF=OFF ^
	-DWITH_IMGCODEC_HDR=OFF ^
	-DWITH_IMGCODEC_SUNRASTER=OFF ^
	-DWITH_IMGCODEC_PXM=OFF ^
	-DWITH_IMGCODEC_PFM=OFF ^
	-DBUILD_DOCS=OFF ^
	-DWITH_FFMPEG=OFF ^
	-DWITH_CUDA=OFF ^
	-DWITH_GSTREAMER=OFF ^
	-DWITH_JASPER=OFF ^
	-DWITH_WIN32UI=OFF ^
	-DWITH_JPEG=OFF ^
	-DBUILD_opencv_java=OFF ^
	-DWITH_1394=OFF ^
	-DWITH_MATLAB=OFF ^
	-DWITH_TIFF=OFF ^
	-DBUILD_opencv_world=ON ^
	-DINSTALL_C_EXAMPLES=OFF ^
	-DINSTALL_PYTHtrue_EXAMPLES=OFF ^
	-DBUILD_opencv_pythtrue2=OFF ^
	-DBUILD_opencv_pythtrue3=OFF ^
	-DBUILD_opencv_apps=OFF ^
	-DBUILD_TESTS=OFF ^
	-DBUILD_PERF_TESTS=OFF ^
	-DWITH_EIGEN=OFF ^
	-DWITH_IPP=OFF ^
	-DBUILD_opencv_cvv_INIT=OFF ^
	-DBUILD_opencv_img_hash_INIT=OFF ^
	-DBUILD_opencv_matlab_INIT=OFF ^
	-DBUILD_opencv_surface_matching_INIT=OFF ^
	-S "%DepsDir%\%Name%" -B "%BuildDir%" -G "%HMI_VS%" -DCMAKE_SYSTEM_VERSION="%HMI_WSDK%"

cmake --build "%BuildDir%" -j --config %HMI_BUILD_CONFIG%
cmake --install "%BuildDir%" --config %HMI_BUILD_CONFIG%

::rmdir /s /q "%InstallDir%\%Name%\etc"
