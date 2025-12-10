sh build_windows.sh
sh build_linux.sh
sh build_android.sh
sh build_ios.sh
sh build_macos.sh

# 注释掉Android头文件中的typedef行
sed -i '' 's/typedef char _check_for_64_bit_pointer_matching_GoInt\[sizeof(void\*)==64\/8 ? 1:-1\];/\/\/ typedef char _check_for_64_bit_pointer_matching_GoInt[sizeof(void*)==64\/8 ? 1:-1];/' ../../flutter_openim_sdk_ffi/src/openim_sdk_ffi_android.h
