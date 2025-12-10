unset CGO_CFLAGS
unset CGO_LDFLAGS
export GOOS=linux
export GOARCH=amd64
export CGO_ENABLED=1
export CC=x86_64-linux-gnu-gcc

go build -tags linux -ldflags="-s -w" -trimpath -v \
-o "../build/linux/libopenim_sdk_ffi.so" -buildmode=c-shared

chmod +x ../build/linux/libopenim_sdk_ffi.so
upx --best ../build/linux/libopenim_sdk_ffi.so
mv ../build/linux/libopenim_sdk_ffi.h ../../flutter_openim_sdk_ffi/src/openim_sdk_ffi_linux.h
mv ../build/linux/libopenim_sdk_ffi.so ../../flutter_openim_sdk_ffi/linux/libopenim_sdk_ffi.so