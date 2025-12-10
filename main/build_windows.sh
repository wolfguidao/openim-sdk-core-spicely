unset CGO_CFLAGS
unset CGO_LDFLAGS
export GOOS=windows
export GOARCH=amd64
export CGO_ENABLED=1
export CC=x86_64-w64-mingw32-gcc

go build -tags windows -ldflags="-s -w" -trimpath -v -o "../build/windows/libopenim_sdk_ffi.dll" -buildmode=c-shared
upx --best ../build/windows/libopenim_sdk_ffi.dll
mv ../build/windows/libopenim_sdk_ffi.h ../../flutter_openim_sdk_ffi/src/openim_sdk_ffi_windows.h
mv ../build/windows/libopenim_sdk_ffi.dll ../../flutter_openim_sdk_ffi/windows/libopenim_sdk_ffi.dll