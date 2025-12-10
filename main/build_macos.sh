export CFLAGS_ARM64="-Os -mmacosx-version-min=13.0 -arch arm64 -isysroot $(xcrun -sdk macosx --show-sdk-path)"
export CGO_LDFLAGS_ARM64="-Os -mmacosx-version-min=13.0 -arch arm64 -isysroot $(xcrun -sdk macosx --show-sdk-path)"
CGO_ENABLED=1 GOARCH=arm64 GOOS=darwin CC="clang $CFLAGS_ARM64 $CGO_LDFLAGS_ARM64" go build -tags macosx -ldflags="-linkmode=external -s -w" -trimpath -v -o ../build/macos/libopenim_sdk_ffi_arm64.a -buildmode c-archive
xcrun -sdk macosx clang -arch arm64 -fpic -shared -Wl,-all_load ../build/macos/libopenim_sdk_ffi_arm64.a -framework CoreFoundation -framework Security -lresolv -mmacosx-version-min=13.0 -o ../build/macos/libopenim_sdk_ffi.dylib
rm -rf ../build/macos/libopenim_sdk_ffi_arm64.a
strip -S ../build/macos/libopenim_sdk_ffi.dylib
install_name_tool -id @rpath/libopenim_sdk_ffi.dylib ../build/macos/libopenim_sdk_ffi.dylib
mv ../build/macos/libopenim_sdk_ffi.dylib ../../flutter_openim_sdk_ffi/macos/libopenim_sdk_ffi.dylib
mv ../build/macos/libopenim_sdk_ffi_arm64.h ../../flutter_openim_sdk_ffi/src/openim_sdk_ffi_apple.h