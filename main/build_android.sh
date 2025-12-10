unset CGO_CFLAGS
unset CGO_LDFLAGS
export GOOS=android
export GOARCH=arm64
export CGO_ENABLED=1
export CC=/Users/Spicely/Library/Android/sdk/ndk/26.1.10909125/toolchains/llvm/prebuilt/darwin-x86_64/bin/aarch64-linux-android21-clang

go build -buildmode=c-shared -ldflags="-linkmode=external -s -w" -o ../build/libs/arm64-v8a/libopenim_sdk_ffi.so 

unset CGO_CFLAGS
unset CGO_LDFLAGS
export GOOS=android
export GOARCH=arm
export CGO_ENABLED=1
export CC=/Users/Spicely/Library/Android/sdk/ndk/26.1.10909125/toolchains/llvm/prebuilt/darwin-x86_64/bin/armv7a-linux-androideabi21-clang

go build -buildmode=c-shared -ldflags="-linkmode=external -s -w" -o ../build/libs/armeabi-v7a/libopenim_sdk_ffi.so

mv ../build/libs/arm64-v8a/libopenim_sdk_ffi.h ../../flutter_openim_sdk_ffi/src/openim_sdk_ffi_android.h
rm -rf ../build/libs/arm64-v8a/libopenim_sdk_ffi.h
rm -rf ../build/libs/armeabi-v7a/libopenim_sdk_ffi.h
chmod +x ../build/libs/arm64-v8a/libopenim_sdk_ffi.so
chmod +x ../build/libs/armeabi-v7a/libopenim_sdk_ffi.so
upx --android-shlib ../build/libs/arm64-v8a/libopenim_sdk_ffi.so
upx --android-shlib ../build/libs/armeabi-v7a/libopenim_sdk_ffi.so
rsync -av --delete ../build/libs ../../flutter_openim_sdk_ffi/android