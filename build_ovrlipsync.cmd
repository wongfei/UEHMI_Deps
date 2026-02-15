call "_build_config.cmd"

xcopy "%DepsDir%\OVRLipSync" "%InstallDir%\OVRLipSync\" /E /Q /Y
