export CFLAGS="-arch arm64 -miphoneos-version-min=12.0 -isysroot "$(xcrun -sdk iphoneos --show-sdk-path) 
export CGO_LDFLAGS="-arch arm64 -miphoneos-version-min=12.0 -isysroot "$(xcrun -sdk iphoneos --show-sdk-path)  
CGO_ENABLED=1 GOARCH=arm64 GOOS=ios CC="clang $CFLAGS $CGO_LDFLAGS" go build -tags ios -ldflags "-s -w" -trimpath -v -o ../build/ios/libopenim_sdk_ffi.a -buildmode c-archive
xcrun -sdk iphoneos clang -arch arm64 -fpic -shared -Wl,-all_load ../build/ios/libopenim_sdk_ffi.a -framework CoreFoundation -framework Security -lresolv -miphoneos-version-min=12.0 -compatibility_version 1.0.0 -o ../build/ios/libopenim_sdk_ffi.dylib
rm -rf ../build/ios/libopenim_sdk_ffi.a
strip -S ../build/ios/libopenim_sdk_ffi.dylib
lipo -create ../build/ios/libopenim_sdk_ffi.dylib -output ../build/ios/openim_sdk_ffi
install_name_tool -id @rpath/openim_sdk_ffi.framework/openim_sdk_ffi ../build/ios/openim_sdk_ffi
mv ../build/ios/libopenim_sdk_ffi.h ../../flutter_openim_sdk_ffi/src/libopenim_sdk_ffi_ios.h
mv ../build/ios/openim_sdk_ffi ../../flutter_openim_sdk_ffi/ios/openim_sdk_ffi.framework/openim_sdk_ffi