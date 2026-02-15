import clang.cindex # pip install ctypeslib2

clang.cindex.Config.set_library_path('d:/dev/clang+llvm-20.1.5-x86_64-pc-windows-msvc/bin')

inHeader = './sherpaonnx/sherpa-onnx/c-api/c-api.h'

idx = clang.cindex.Index.create()
tu = idx.parse(inHeader, args=["-Iinclude"])

print("#include \"sherpa-onnx/c-api/c-api.h\"")

print("\nstruct FSherpaAPI {")

for c in tu.cursor.get_children():
    if c.kind == clang.cindex.CursorKind.FUNCTION_DECL:
        name = c.spelling
        if 'SherpaOnnx' in name:
            rtype = c.result_type.spelling
            params = ", ".join(p.type.spelling for p in c.get_arguments())
            print(f"\ttypedef {rtype} (*{name}_ft)({params});")
            print(f"\t{name}_ft {name}_fp = {{}};")

print("};")

#print("\nextern FSherpaAPI GSherpaAPI;")

print("\ninline bool LoadSherpaAPI(const FString& DllPath, FSherpaAPI& OutAPI) {")

print("\tvoid* DllHandle = FPlatformProcess::GetDllHandle(*DllPath); if (!DllHandle) return false;")

for c in tu.cursor.get_children():
    if c.kind == clang.cindex.CursorKind.FUNCTION_DECL:
        name = c.spelling
        if 'SherpaOnnx' in name:
            rtype = c.result_type.spelling
            params = ", ".join(p.type.spelling for p in c.get_arguments())
            print(f"\tOutAPI.{name}_fp = (FSherpaAPI::{name}_ft)FPlatformProcess::GetDllExport(DllHandle, TEXT(\"{name}\"));")

print("\treturn OutAPI.SherpaOnnxGetVersionStr_fp ? true : false;")
print("}")
