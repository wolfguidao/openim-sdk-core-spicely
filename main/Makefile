android:
	GOARCH=arm64 GOOS=android CGO_ENABLED=1 CC=/Users/Spicely/Library/Android/sdk/ndk/26.1.10909125/toolchains/llvm/prebuilt/darwin-x86_64/bin/aarch64-linux-android21-clang go build -buildmode=c-shared -ldflags="-linkmode=external -s -w" -o ../build/libs/arm64-v8a/libopenim_sdk_ffi.so 
	GOARCH=arm GOOS=android CGO_ENABLED=1 CC=/Users/Spicely/Library/Android/sdk/ndk/26.1.10909125/toolchains/llvm/prebuilt/darwin-x86_64/bin/armv7a-linux-androideabi21-clang go build -buildmode=c-shared -ldflags="-linkmode=external -s -w" -o ../build/libs/armeabi-v7a/libopenim_sdk_ffi.so
	
	mv ../build/libs/arm64-v8a/libopenim_sdk_ffi.h ../../flutter_openim_sdk_ffi/src/openim_sdk_ffi_android.h
	rm -rf ../build/libs/arm64-v8a/libopenim_sdk_ffi.h
	rm -rf ../build/libs/armeabi-v7a/libopenim_sdk_ffi.h
	chmod +x ../build/libs/arm64-v8a/libopenim_sdk_ffi.so
	chmod +x ../build/libs/armeabi-v7a/libopenim_sdk_ffi.so
	upx --android-shlib ../build/libs/arm64-v8a/libopenim_sdk_ffi.so
	upx --android-shlib ../build/libs/armeabi-v7a/libopenim_sdk_ffi.so
	rsync -av --delete ../build/libs ../../flutter_openim_sdk_ffi/android

windows:
	SET CGO_ENABLED=1 CC=x86_64-w64-mingw32-gcc CXX=x86_64-w64-mingw32-g++ GOOS=windows GOARCH=amd64
	go build -buildmode=c-shared -ldflags="-s -w" -o ../build/windows/libopenim_sdk_ffi.dll
	upx --best ../build/windows/libopenim_sdk_ffi.dll
	# lib /machine:x64 /def:../build/windows/libopenim_sdk_ffi.def /out:../build/windows/libopenim_sdk_ffi.lib
	# rm -rf ../build/windows/libopenim_sdk_ffi.exp
	mv ../build/windows/libopenim_sdk_ffi.h ../../flutter_openim_sdk_ffi/src/openim_sdk_ffi_windows.h
	mv ../build/windows/libopenim_sdk_ffi.dll ../../flutter_openim_sdk_ffi/windows/libopenim_sdk_ffi.dll
	# mv ../build/windows/libopenim_sdk_ffi.lib ../../flutter_openim_sdk_ffi/windows/libopenim_sdk_ffi.lib

macos:
	# arm64平台
	export CFLAGS_ARM64="-Os -mmacosx-version-min=13.0 -arch arm64 -isysroot $(xcrun -sdk macosx --show-sdk-path)"
	export CGO_LDFLAGS_ARM64="-Os -mmacosx-version-min=13.0 -arch arm64 -isysroot $(xcrun -sdk macosx --show-sdk-path)"
	CGO_ENABLED=1 GOARCH=arm64 GOOS=darwin CC="clang $CFLAGS_ARM64 $CGO_LDFLAGS_ARM64" go build -tags macosx -ldflags="-linkmode=external -s -w" -trimpath -v -o ../build/macos/libopenim_sdk_ffi_arm64.a -buildmode c-archive
	xcrun -sdk macosx clang -arch arm64 -fpic -shared -Wl,-all_load ../build/macos/libopenim_sdk_ffi_arm64.a -framework CoreFoundation -framework Security -lresolv -mmacosx-version-min=13.0 -o ../build/macos/libopenim_sdk_ffi.dylib
	rm -rf ../build/macos/libopenim_sdk_ffi_arm64.a
	strip -S ../build/macos/libopenim_sdk_ffi.dylib
	install_name_tool -id @rpath/libopenim_sdk_ffi.dylib ../build/macos/libopenim_sdk_ffi.dylib
	mv ../build/macos/libopenim_sdk_ffi.dylib ../../flutter_openim_sdk_ffi/macos/libopenim_sdk_ffi.dylib
	mv ../build/macos/libopenim_sdk_ffi_arm64.h ../../flutter_openim_sdk_ffi/src/openim_sdk_ffi_apple.h

	# 两个平台
	export CFLAGS_ARM64="-Os -mmacosx-version-min=13.0 -arch arm64 -isysroot $(xcrun -sdk macosx --show-sdk-path)"
	export CGO_LDFLAGS_ARM64="-Os -mmacosx-version-min=13.0 -arch arm64 -isysroot $(xcrun -sdk macosx --show-sdk-path)"
	CGO_ENABLED=1 GOARCH=arm64 GOOS=darwin CC="clang $CFLAGS_ARM64 $CGO_LDFLAGS_ARM64" go build -tags macosx -ldflags="-linkmode=external -s -w" -trimpath -v -o ../build/macos/libopenim_sdk_ffi_arm64.a -buildmode c-archive
	xcrun -sdk macosx clang -arch arm64 -fpic -shared -Wl,-all_load ../build/macos/libopenim_sdk_ffi_arm64.a -framework CoreFoundation -framework Security -lresolv -mmacosx-version-min=13.0 -o ../build/macos/libopenim_sdk_ffi_arm64.dylib
	rm -rf ../build/macos/libopenim_sdk_ffi_arm64.a
	strip -S ../build/macos/libopenim_sdk_ffi_arm64.dylib
	export CFLAGS_X86_64="-Os -mmacosx-version-min=13.0 -arch x86_64 -isysroot $(xcrun -sdk macosx --show-sdk-path)"
	export CGO_LDFLAGS_X86_64="-Os -mmacosx-version-min=13.0 -arch x86_64 -isysroot $(xcrun -sdk macosx --show-sdk-path)"
	CGO_ENABLED=1 GOARCH=amd64 GOOS=darwin CC="clang $CFLAGS_X86_64 $CGO_LDFLAGS_X86_64" go build -tags macosx -ldflags="-linkmode=external -s -w" -trimpath -v -o ../build/macos/libopenim_sdk_ffi_x86_64.a -buildmode c-archive
	xcrun -sdk macosx clang -arch x86_64 -fpic -shared -Wl,-all_load ../build/macos/libopenim_sdk_ffi_x86_64.a -framework CoreFoundation -framework Security -lresolv -mmacosx-version-min=13.0 -o ../build/macos/libopenim_sdk_ffi_x86_64.dylib
	rm -rf ../build/macos/libopenim_sdk_ffi_x86_64.a
	strip -S ../build/macos/libopenim_sdk_ffi_x86_64.dylib
	lipo -create ../build/macos/libopenim_sdk_ffi_arm64.dylib ../build/macos/libopenim_sdk_ffi_x86_64.dylib -output ../build/macos/libopenim_sdk_ffi.dylib
	rm -rf ../build/macos/libopenim_sdk_ffi_arm64.dylib ../build/macos/libopenim_sdk_ffi_x86_64.dylib ../build/macos/libopenim_sdk_ffi_x86_64.h
	strip -S ../build/macos/libopenim_sdk_ffi.dylib
	install_name_tool -id @rpath/libopenim_sdk_ffi.dylib ../build/macos/libopenim_sdk_ffi.dylib
	mv ../build/macos/libopenim_sdk_ffi.dylib ../../flutter_openim_sdk_ffi/macos/libopenim_sdk_ffi.dylib
	mv ../build/macos/libopenim_sdk_ffi_arm64.h ../../flutter_openim_sdk_ffi/src/openim_sdk_ffi_apple.h

ios:
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


	export CFLAGS="-arch arm64 -miphoneos-version-min=9.0 -isysroot $(xcrun -sdk iphoneos --show-sdk-path)"
	export CGO_LDFLAGS="-arch arm64 -miphoneos-version-min=9.0 -isysroot $(xcrun -sdk iphoneos --show-sdk-path)"
	CGO_ENABLED=1 GOARCH=arm64 GOOS=darwin CC="clang $CFLAGS $CGO_LDFLAGS" go build -tags ios -buildmode=c-shared -ldflags="-w -s" -trimpath -o ../build/ios/libopenim_sdk_ffi_arm64.dylib openim_sdk_ffi.go
	export CFLAGS="-arch x86_64 -mios-simulator-version-min=9.0 -isysroot $(xcrun --sdk iphonesimulator --show-sdk-path)"
	export CGO_LDFLAGS="-arch x86_64 -mios-simulator-version-min=9.0 -isysroot $(xcrun --sdk iphonesimulator --show-sdk-path)"
	CGO_ENABLED=1 GOARCH=amd64 GOOS=darwin CC="clang $CFLAGS $CGO_LDFLAGS" go build -tags ios -buildmode=c-shared -ldflags="-w -s" -trimpath -o ../build/ios/libopenim_sdk_ffi_x86.dylib openim_sdk_ffi.go
	lipo -create ../build/ios/libopenim_sdk_ffi_arm64.dylib ../build/ios/libopenim_sdk_ffi_x86.dylib -output ../build/ios/libopenim_sdk_ffi.dylib
	rm -rf ../build/ios/libopenim_sdk_ffi_arm64.dylib ../build/ios/libopenim_sdk_ffi_x86.dylib  ../build/ios/libopenim_sdk_ffi_x86.h
	install_name_tool -id @rpath/libopenim_sdk_ffi.dylib ../build/ios/libopenim_sdk_ffi.dylib
	mv ../build/ios/libopenim_sdk_ffi.dylib ../../flutter_openim_sdk_ffi/ios/libopenim_sdk_ffi.dylib

linux:
	# macos build
	GOOS=linux GOARCH=amd64 CGO_ENABLED=1 CC=$(brew --prefix)/bin/x86_64-linux-gnu-gcc go build -tags linux -ldflags="-s -w" -trimpath -v  -o "../build/linux/libopenim_sdk_ffi.so" -buildmode=c-shared
	
	go build -tags linux -ldflags="-s -w" -trimpath -v -o "../build/linux/libopenim_sdk_ffi.so" -buildmode c-shared 
	chmod +x ../build/linux/libopenim_sdk_ffi.so
	upx --best ../build/linux/libopenim_sdk_ffi.so
	mv ../build/linux/libopenim_sdk_ffi.h ../../flutter_openim_sdk_ffi/src/openim_sdk_ffi_linux.h
	mv ../build/linux/libopenim_sdk_ffi.so ../../flutter_openim_sdk_ffi/linux/libopenim_sdk_ffi.so
	
codesign -f -s "Apple Development: zheng tang (HS 53J 8AN55)" ../build/macos/libopenimSDK.dylib
xcrun -sdk iphoneos clang -arch armv7 -fpic -shared -Wl,-all_load libopenim_sdk_ffi.dylib -framework Corefoundation -o libopenim_sdk_ffi.dylib


nm -D openim_sdk_ffi.so

nm -gU flutter_openim_sdk_ffi

dumpbin /exports openim_sdk_ffi.dll

lipo -info ../build/macos/libopenim_sdk_ffi_arm64.dylib
lipo -info ../build/macos/libopenim_sdk_ffi_x86_64.dylib
lipo -info ../../flutter_openim_sdk_ffi/macos/libopenim_sdk_ffi.dylib


upx -9 libopenim_sdk_ffi.so
otool -L 
vtool -show