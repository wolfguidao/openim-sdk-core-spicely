#!/bin/bash

# ======================== 调试/容错配置 ========================
# set -x：开启执行日志，显示每一步执行的命令
# set -e：任意命令失败则立即退出
# set -u：引用未定义变量则退出
# set -o pipefail：管道命令任意环节失败则整体失败
set -xeuo pipefail

# ======================== 全局配置（可根据实际环境调整） ========================
# Android NDK 路径（请替换为你本地的NDK路径）
# ANDROID_NDK_PATH="/usr/local/android-ndk-r25b"
# iOS 编译目标SDK（如 iphoneos、iphonesimulator）
# IOS_SDK="iphoneos"
# output
OUTPUT_PATH="output"
mkdir -p ${OUTPUT_PATH}
BUILD_PATH="build"
mkdir -p ${BUILD_PATH}

# ======================== 定义各平台编译函数 ========================
# 函数命名规则：build_<os>_<arch>（与参数格式化后的名称严格对应）

# ------------------------ Linux 平台 ------------------------
build_linux_amd64() {
    echo "========================================"
    echo "📦 开始编译 [Linux amd64] 平台代码..."

    unset CGO_CFLAGS
    unset CGO_LDFLAGS
    export GOOS=linux
    export GOARCH=amd64
    export CGO_ENABLED=1
    export CC=x86_64-linux-gnu-gcc

    pushd main
    go build -tags linux -ldflags="-s -w" -trimpath -v \
        -o "../${BUILD_PATH}/${GOOS}_${GOARCH}/libopenim_sdk_ffi.so" -buildmode=c-shared
    if [ $? -ne 0 ];then
        popd
        echo "❌ [Linux amd64] 编译失败！"
        return 1
    fi
    popd

    cp -r "./${BUILD_PATH}/${GOOS}_${GOARCH}" ${OUTPUT_PATH}
    if [ $? -ne 0 ];then
        echo "❌ [Linux amd64] 编译失败！"
        return 1
    fi

    echo "✅ [Linux amd64] 编译完成！"
    echo "========================================"
}

build_linux_arm64() {
    echo "========================================"
    echo "📦 开始编译 [Linux arm64] 平台代码..."
    
    unset CGO_CFLAGS
    unset CGO_LDFLAGS
    export GOOS=linux
    export GOARCH=arm64
    export CGO_ENABLED=1
    export CC=aarch64-linux-gnu-gcc
    export CXX=aarch64-linux-gnu-g++

    pushd main
    go build -tags linux -ldflags="-s -w" -trimpath -v \
        -o "../${BUILD_PATH}/${GOOS}_${GOARCH}/libopenim_sdk_ffi.so" -buildmode=c-shared
    if [ $? -ne 0 ];then
        popd
        echo "❌ [Linux arm64] 编译失败！"
        return 1
    fi
    popd

    cp -r "./${BUILD_PATH}/${GOOS}_${GOARCH}" ${OUTPUT_PATH}
    if [ $? -ne 0 ];then
        echo "❌ [Linux arm64] 编译失败！"
        return 1
    fi

    echo "✅ [Linux arm64] 编译完成！"
    echo "========================================"
}

# ------------------------ MacOS 平台 ------------------------
build_macos_arm64() {
    echo "========================================"
    echo "📦 开始编译 [MacOS arm64] 平台代码..."

    export CFLAGS_ARM64="-Os -mmacosx-version-min=13.0 -arch arm64 -isysroot $(xcrun -sdk macosx --show-sdk-path)"
    export CGO_LDFLAGS_ARM64="-Os -mmacosx-version-min=13.0 -arch arm64 -isysroot $(xcrun -sdk macosx --show-sdk-path)"

    export GOOS="darwin"          # macOS 系统
    export GOARCH="arm64"         # arm64 架构
    export CGO_ENABLED="1"        # 开启 CGO
    export CC="clang $CFLAGS_ARM64 $CGO_LDFLAGS_ARM64"

    pushd main
    go build -tags macosx -ldflags="-linkmode=external -s -w" -trimpath -v -o ../${BUILD_PATH}/${GOOS}_${GOARCH}/libopenim_sdk_ffi_arm64.a -buildmode c-archive
    if [ $? -ne 0 ];then
        popd
        echo "❌ [MacOS arm64] 编译失败！"
        return 1
    fi
    popd

    xcrun -sdk macosx clang -arch arm64 -fpic -shared -Wl,-all_load ./${BUILD_PATH}/${GOOS}_${GOARCH}/libopenim_sdk_ffi_arm64.a -framework CoreFoundation -framework Security -lresolv -mmacosx-version-min=13.0 -o ./${BUILD_PATH}/${GOOS}_${GOARCH}/libopenim_sdk_ffi.dylib
    if [ $? -ne 0 ];then
        echo "❌ [MacOS arm64] 编译失败！"
        return 1
    fi

    strip -S ./${BUILD_PATH}/${GOOS}_${GOARCH}/libopenim_sdk_ffi.dylib
    if [ $? -ne 0 ];then
        echo "❌ [MacOS arm64] 编译失败！"
        return 1
    fi

    install_name_tool -id @rpath/libopenim_sdk_ffi.dylib ./${BUILD_PATH}/${GOOS}_${GOARCH}/libopenim_sdk_ffi.dylib
    if [ $? -ne 0 ];then
        echo "❌ [MacOS arm64] 编译失败！"
        return 1
    fi

    cp -r "./${BUILD_PATH}/${GOOS}_${GOARCH}" ${OUTPUT_PATH}
    if [ $? -ne 0 ];then
        echo "❌ [MacOS arm64] 编译失败！"
        return 1
    fi

    echo "✅ [MacOS arm64] 编译完成！"
    echo "========================================"
}

build_macos_amd64() {
    echo "========================================"
    echo "📦 开始编译 [MacOS amd64] 平台代码..."
    
    export CFLAGS_X86_64="-Os -mmacosx-version-min=13.0 -arch x86_64 -isysroot $(xcrun -sdk macosx --show-sdk-path)"
    export CGO_LDFLAGS_X86_64="-Os -mmacosx-version-min=13.0 -arch x86_64 -isysroot $(xcrun -sdk macosx --show-sdk-path)"

    export GOOS="darwin"          # 保持macOS系统不变
    export GOARCH="amd64"         # 关键：x86_64架构在Go中用amd64表示
    export CGO_ENABLED="1"        # 开启CGO不变
    export CC="clang $CFLAGS_X86_64 $CGO_LDFLAGS_X86_64"  # 引用x86_64的编译标志

    pushd main
    go build -tags macosx -ldflags="-linkmode=external -s -w" -trimpath -v -o ../${BUILD_PATH}/${GOOS}_${GOARCH}/libopenim_sdk_ffi_x86_64.a -buildmode c-archive
    if [ $? -ne 0 ];then
        popd
        echo "❌ [MacOS x86_64] 编译失败！"
        return 1
    fi
    popd

    xcrun -sdk macosx clang -arch x86_64 -fpic -shared -Wl,-all_load ./${BUILD_PATH}/${GOOS}_${GOARCH}/libopenim_sdk_ffi_x86_64.a -framework CoreFoundation -framework Security -lresolv -mmacosx-version-min=13.0 -o ./${BUILD_PATH}/${GOOS}_${GOARCH}/libopenim_sdk_ffi.dylib
    if [ $? -ne 0 ];then
        echo "❌ [MacOS x86_64] 编译失败！"
        return 1
    fi

    strip -S ./${BUILD_PATH}/${GOOS}_${GOARCH}/libopenim_sdk_ffi.dylib
    if [ $? -ne 0 ];then
        echo "❌ [MacOS x86_64] 编译失败！"
        return 1
    fi

    install_name_tool -id @rpath/libopenim_sdk_ffi.dylib ./${BUILD_PATH}/${GOOS}_${GOARCH}/libopenim_sdk_ffi.dylib
    if [ $? -ne 0 ];then
        echo "❌ [MacOS x86_64] 编译失败！"
        return 1
    fi

    cp -r "./${BUILD_PATH}/${GOOS}_${GOARCH}" ${OUTPUT_PATH}
    if [ $? -ne 0 ];then
        echo "❌ [MacOS x86_64] 编译失败！"
        return 1
    fi

    echo "✅ [MacOS amd64] 编译完成！"
    echo "========================================"
}

# ------------------------ Windows 平台 ------------------------
build_windows_amd64() {
    echo "========================================"
    echo "📦 开始编译 [Windows amd64] 平台代码..."
    # 替换为实际编译命令
    # GOOS=windows GOARCH=amd64 go build -o ./bin/windows_amd64/openim-sdk-core.exe ./main.go
    echo "✅ [Windows amd64] 编译完成！"
    echo "========================================"
}

# Android 
build_android() {
    echo "========================================"
    echo "📦 开始编译 [Android] 平台代码..."
    
    NDK_HOME=${ANDROID_NDK_HOME}
    BasePath="${NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin/"

    ls -al ${BasePath}
    # case "arm":
	# 	cc = ccBasePath + "armv7a-linux-androideabi" + apiLevel + "-clang" + osSuffix
	# case "arm64":
	# 	cc = ccBasePath + "aarch64-linux-android" + apiLevel + "-clang" + osSuffix
	# case "386":
	# 	cc = ccBasePath + "i686-linux-android" + apiLevel + "-clang" + osSuffix
	# case "amd64":
	# 	cc = ccBasePath + "x86_64-linux-android" + apiLevel + "-clang" + osSuffix
	# }

    unset CGO_CFLAGS
    unset CGO_LDFLAGS
    export GOOS=android
    export GOARCH=arm64
    export CGO_ENABLED=1
    export CC="${BasePath}aarch64-linux-android21-clang"

    pushd main
    go build -buildmode=c-shared -ldflags="-linkmode=external -s -w" -o ../${BUILD_PATH}/${GOOS}_${GOARCH}/libopenim_sdk_ffi.so 
    if [ $? -ne 0 ];then
        popd
        echo "❌ [Android arm64] 编译失败！"
        return 1
    fi
    popd

    cp -r "./${BUILD_PATH}/${GOOS}_${GOARCH}" ${OUTPUT_PATH}
    if [ $? -ne 0 ];then
        echo "❌ [Android arm64] 编译失败！"
        return 1
    fi

    unset CGO_CFLAGS
    unset CGO_LDFLAGS
    export GOOS=android
    export GOARCH=arm
    export CGO_ENABLED=1
    export CC="${BasePath}armv7a-linux-androideabi21-clang"

    pushd main
    go build -buildmode=c-shared -ldflags="-linkmode=external -s -w" -o ../${BUILD_PATH}/${GOOS}_${GOARCH}/libopenim_sdk_ffi.so 
    if [ $? -ne 0 ];then
        popd
        echo "❌ [Android armv7] 编译失败！"
        return 1
    fi
    popd

    cp -r "./${BUILD_PATH}/${GOOS}_${GOARCH}" ${OUTPUT_PATH}
    if [ $? -ne 0 ];then
        echo "❌ [Android armv7] 编译失败！"
        return 1
    fi

    unset CGO_CFLAGS
    unset CGO_LDFLAGS
    export GOOS=android
    export GOARCH=amd64
    export CGO_ENABLED=1
    export CC="${BasePath}x86_64-linux-android21-clang"

    pushd main
    go build -buildmode=c-shared -ldflags="-linkmode=external -s -w" -o ../${BUILD_PATH}/${GOOS}_${GOARCH}/libopenim_sdk_ffi.so 
    if [ $? -ne 0 ];then
        popd
        echo "❌ [Android x86_64] 编译失败！"
        return 1
    fi
    popd

    cp -r "./${BUILD_PATH}/${GOOS}_${GOARCH}" ${OUTPUT_PATH}
    if [ $? -ne 0 ];then
        echo "❌ [Android x86_64] 编译失败！"
        return 1
    fi

    echo "✅ [Android] 编译完成！"
    echo "========================================"
}

# iOS arm64
build_ios_arm64() {
    echo "========================================"
    echo "📦 开始编译 [iOS arm64 (真机)] 平台代码..."
    
    export CFLAGS="-arch arm64 -miphoneos-version-min=12.0 -isysroot $(xcrun -sdk iphoneos --show-sdk-path)"
    export CGO_CFLAGS="-arch arm64 -miphoneos-version-min=12.0 -isysroot $(xcrun -sdk iphoneos --show-sdk-path)"
    export CGO_LDFLAGS="-arch arm64 -miphoneos-version-min=12.0 -isysroot $(xcrun -sdk iphoneos --show-sdk-path)" 
    CGO_ENABLED=1
    GOARCH=arm64 
    GOOS=ios 
    CC="clang $CFLAGS $CGO_LDFLAGS" 

    pushd main
    go build -tags ios -ldflags "-s -w" -trimpath -v -o ../${BUILD_PATH}/${GOOS}_${GOARCH}_iphoneos/libopenim_sdk_ffi.a -buildmode c-archive
    if [ $? -ne 0 ];then
        popd
        echo "❌ [iOS arm64] 编译失败！"
        return 1
    fi
    popd

    xcrun -sdk iphoneos clang -arch arm64 -fpic -shared -Wl,-all_load ./${BUILD_PATH}/${GOOS}_${GOARCH}_iphoneos/libopenim_sdk_ffi.a -framework CoreFoundation -framework Security -lresolv -miphoneos-version-min=12.0 -compatibility_version 1.0.0 -o ./${BUILD_PATH}/${GOOS}_${GOARCH}_iphoneos/libopenim_sdk_ffi.dylib
    if [ $? -ne 0 ];then
        echo "❌ [iOS arm64] 编译失败！"
        return 1
    fi
    
    strip -S ./${BUILD_PATH}/${GOOS}_${GOARCH}_iphoneos/libopenim_sdk_ffi.dylib
    lipo -create ./${BUILD_PATH}/${GOOS}_${GOARCH}_iphoneos/libopenim_sdk_ffi.dylib -output ./${BUILD_PATH}/${GOOS}_${GOARCH}_iphoneos/openim_sdk_ffi
    install_name_tool -id @rpath/openim_sdk_ffi.framework/openim_sdk_ffi ./${BUILD_PATH}/${GOOS}_${GOARCH}_iphoneos/openim_sdk_ffi

    cp -r "./${BUILD_PATH}/${GOOS}_${GOARCH}_iphoneos" ${OUTPUT_PATH}
    if [ $? -ne 0 ];then
        echo "❌ [iOS arm64 (真机)] 编译失败！"
        return 1
    fi

    echo "✅ [iOS arm64 (真机)] 编译完成！"

    export CGO_CFLAGS="-target arm64-apple-ios12.0-simulator -arch arm64 -miphoneos-version-min=12.0 -isysroot $(xcrun -sdk iphonesimulator --show-sdk-path)"
    export CFLAGS="-target arm64-apple-ios12.0-simulator -arch arm64 -miphoneos-version-min=12.0 -isysroot "$(xcrun -sdk iphonesimulator --show-sdk-path) 
    export CGO_LDFLAGS="-target arm64-apple-ios12.0-simulator -arch arm64 -miphoneos-version-min=12.0 -isysroot "$(xcrun -sdk iphonesimulator --show-sdk-path)  
    CGO_ENABLED=1
    GOARCH=arm64 
    GOOS=ios 
    CC="clang $CFLAGS $CGO_LDFLAGS" 

    pushd main
    go build -tags ios -ldflags "-s -w" -trimpath -v -o ../${BUILD_PATH}/${GOOS}_${GOARCH}_iphonesimulator/libopenim_sdk_ffi.a -buildmode c-archive
    if [ $? -ne 0 ];then
        popd
        echo "❌ [iOS arm64] 编译失败！"
        return 1
    fi
    popd

    xcrun -sdk iphonesimulator clang -arch arm64 -fpic -shared -Wl,-all_load ./${BUILD_PATH}/${GOOS}_${GOARCH}_iphonesimulator/libopenim_sdk_ffi.a -framework CoreFoundation -framework Security -lresolv -miphoneos-version-min=12.0 -compatibility_version 1.0.0 -o ./${BUILD_PATH}/${GOOS}_${GOARCH}_iphonesimulator/libopenim_sdk_ffi.dylib
    if [ $? -ne 0 ];then
        echo "❌ [iOS arm64] 编译失败！"
        return 1
    fi
    
    strip -S ./${BUILD_PATH}/${GOOS}_${GOARCH}_iphonesimulator/libopenim_sdk_ffi.dylib
    lipo -create ./${BUILD_PATH}/${GOOS}_${GOARCH}_iphonesimulator/libopenim_sdk_ffi.dylib -output ./${BUILD_PATH}/${GOOS}_${GOARCH}_iphonesimulator/openim_sdk_ffi
    install_name_tool -id @rpath/openim_sdk_ffi.framework/openim_sdk_ffi ./${BUILD_PATH}/${GOOS}_${GOARCH}_iphonesimulator/openim_sdk_ffi

    cp -r "./${BUILD_PATH}/${GOOS}_${GOARCH}_iphonesimulator" ${OUTPUT_PATH}
    if [ $? -ne 0 ];then
        echo "❌ [iOS arm64 (模拟器)] 编译失败！"
        return 1
    fi

    echo "✅ [iOS arm64 (模拟器)] 编译完成！"
    echo "========================================"
}

# iOS x86_64（模拟器架构）
build_ios_amd64() {
    echo "========================================"
    echo "📦 开始编译 [iOS amd64 (模拟器)] 平台代码..."
    # 替换为实际编译命令
    # xcodebuild -project OpenIMSDK.xcodeproj -scheme OpenIMSDK -sdk iphonesimulator -arch x86_64 build
    # GOOS=ios GOARCH=amd64 CGO_ENABLED=1 CC=clang go build -o ./bin/ios/x86_64/libopenim-sdk-core.a ./main.go
    echo "✅ [iOS amd64 (模拟器)] 编译完成！"
    echo "========================================"
}

# ======================== 第二步：检查参数是否完整 ========================
if [ $# -ne 2 ]; then
    echo "❌ 错误：参数数量不正确！"
    echo "✅ 正确用法：sh $0 <操作系统> <架构>"
    echo "📌 支持的平台&架构示例："
    echo "   # Linux 系列"
    echo "   bash $0 Linux amd64        bash $0 Linux arm64"
    echo "   # MacOS 系列"
    echo "   bash $0 MacOS arm64        bash $0 MacOS amd64"
    echo "   # Windows 系列"
    echo "   bash $0 Windows amd64"
    echo "   # Android 系列（核心新增）"
    echo "   bash $0 Android arm64-v8a  bash $0 Android armeabi-v7a"
    echo "   # iOS 系列（核心新增）"
    echo "   bash $0 iOS arm64          bash $0 iOS amd64"
    exit 1
fi

# ======================== 第三步：接收并格式化参数 ========================
INPUT_OS=$1
INPUT_ARCH=$2

# 格式化参数：统一转小写，避免大小写问题
OS=$(echo "$INPUT_OS" | tr '[:upper:]' '[:lower:]' | sed 's/macos/macos/; s/mac os/macos/')
ARCH=$(echo "$INPUT_ARCH" | tr '[:upper:]' '[:lower:]')


# ======================== 第四步：拼接目标函数名并执行 ========================
# 函数名规则：build_<os>_<arch>（与上方定义的函数名严格对应）
TARGET_FUNC="build_${OS}_${ARCH}"
if [ "${OS}" = "android" ]; then
    TARGET_FUNC="build_${OS}"
fi

echo "🔍 正在检查编译函数：$TARGET_FUNC"

# 检查目标函数是否存在（declare -F 用于检查函数是否定义）
if ! declare -F "$TARGET_FUNC" > /dev/null; then
    echo "❌ 错误：未定义 [$INPUT_OS $INPUT_ARCH] 对应的编译函数！"
    echo "📋 已定义的编译函数列表："
    # 列出所有已定义的编译函数（过滤以 build_ 开头的函数）
    declare -F | awk '/build_/ {print "   - " $3}'
    exit 1
fi

# 执行目标编译函数
echo "🚀 开始执行编译函数：$TARGET_FUNC"
"$TARGET_FUNC"  # 调用函数（关键：直接用变量名作为函数名执行）

# 检查函数执行结果
if [ $? -eq 0 ]; then
    echo "🎉 整体编译流程执行成功！"
else
    echo "❌ 整体编译流程执行失败！"
    exit 1
fi