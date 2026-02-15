call "_build_config.cmd"

python gen_sherpaonnx_api.py > "SherpaLoader.h"

::python gen_sherpaonnx_api.py > "%InstallDir%\sherpaonnx\include\sherpa-onnx\c-api\c-api-dynload.h"
