#!/bin/bash

# ======================== 调试/容错配置 ========================
# set -x：开启执行日志，显示每一步执行的命令
# set -e：任意命令失败则立即退出
# set -u：引用未定义变量则退出
# set -o pipefail：管道命令任意环节失败则整体失败
set -xeuo pipefail

# ======================== 全局配置（可根据实际环境调整） ========================
# Android NDK 路径（请替换为你本地的NDK路径）
ANDROID_NDK_PATH="/usr/local/android-ndk-r25b"
# iOS 编译目标SDK（如 iphoneos、iphonesimulator）
IOS_SDK="iphoneos"
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
    echo "📦 开始编译 [Linux x86] 平台代码..."

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
        echo "❌ [Linux x86] 编译失败！"
        return 1
    fi
    popd

    cp -r "./${BUILD_PATH}/${GOOS}_${GOARCH}" ${OUTPUT_PATH}
    if [ $? -ne 0 ];then
        echo "❌ [Linux x86] 编译失败！"
        return 1
    fi

    echo "✅ [Linux x86] 编译完成！"
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
    # 替换为实际编译命令
    # GOOS=darwin GOARCH=arm64 go build -o ./bin/macos_arm64/openim-sdk-core ./main.go
    echo "✅ [MacOS arm64] 编译完成！"
    echo "========================================"
}

build_macos_x86_64() {
    echo "========================================"
    echo "📦 开始编译 [MacOS x86_64] 平台代码..."
    # 替换为实际编译命令
    # GOOS=darwin GOARCH=amd64 go build -o ./bin/macos_x86_64/openim-sdk-core ./main.go
    echo "✅ [MacOS x86_64] 编译完成！"
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

# Android arm64-v8a（主流64位架构）
build_android_arm64-v8a() {
    echo "========================================"
    echo "📦 开始编译 [Android arm64-v8a] 平台代码..."
    # 替换为实际编译命令（示例：NDK 编译 C/C++ 代码）
    # ${ANDROID_NDK_PATH}/ndk-build NDK_PROJECT_PATH=. APP_BUILD_SCRIPT=Android.mk APP_ABI=arm64-v8a
    # GOOS=android GOARCH=arm64 GOARM=8 go build -o ./bin/android/arm64-v8a/openim-sdk-core.so ./main.go
    echo "✅ [Android arm64-v8a] 编译完成！"
    echo "========================================"
}

# Android armeabi-v7a（32位主流架构）
build_android_armeabi-v7a() {
    echo "========================================"
    echo "📦 开始编译 [Android armeabi-v7a] 平台代码..."
    # 替换为实际编译命令
    # ${ANDROID_NDK_PATH}/ndk-build NDK_PROJECT_PATH=. APP_BUILD_SCRIPT=Android.mk APP_ABI=armeabi-v7a
    # GOOS=android GOARCH=arm GOARM=7 go build -o ./bin/android/armeabi-v7a/openim-sdk-core.so ./main.go
    echo "✅ [Android armeabi-v7a] 编译完成！"
    echo "========================================"
}

# Android x86_64（主流64位架构）
build_android_x86_64() {
    echo "========================================"
    echo "📦 开始编译 [Android x86_64] 平台代码..."
    # 替换为实际编译命令（示例：NDK 编译 C/C++ 代码）
    # ${ANDROID_NDK_PATH}/ndk-build NDK_PROJECT_PATH=. APP_BUILD_SCRIPT=Android.mk APP_ABI=arm64-v8a
    # GOOS=android GOARCH=arm64 GOARM=8 go build -o ./bin/android/arm64-v8a/openim-sdk-core.so ./main.go
    echo "✅ [Android x86_64] 编译完成！"
    echo "========================================"
}

# Android 386（32位主流架构）
build_android_386() {
    echo "========================================"
    echo "📦 开始编译 [Android 386] 平台代码..."
    # 替换为实际编译命令
    # ${ANDROID_NDK_PATH}/ndk-build NDK_PROJECT_PATH=. APP_BUILD_SCRIPT=Android.mk APP_ABI=armeabi-v7a
    # GOOS=android GOARCH=arm GOARM=7 go build -o ./bin/android/armeabi-v7a/openim-sdk-core.so ./main.go
    echo "✅ [Android 386] 编译完成！"
    echo "========================================"
}

# iOS arm64（真机架构）
build_ios_arm64() {
    echo "========================================"
    echo "📦 开始编译 [iOS arm64 (真机)] 平台代码..."
    # 替换为实际编译命令（示例：xcodebuild 或 Go 交叉编译）
    # xcodebuild -project OpenIMSDK.xcodeproj -scheme OpenIMSDK -sdk ${IOS_SDK} -arch arm64 build
    # GOOS=ios GOARCH=arm64 CGO_ENABLED=1 CC=clang go build -o ./bin/ios/arm64/libopenim-sdk-core.a ./main.go
    echo "✅ [iOS arm64 (真机)] 编译完成！"
    echo "========================================"
}

# iOS x86_64（模拟器架构）
build_ios_x86_64() {
    echo "========================================"
    echo "📦 开始编译 [iOS x86_64 (模拟器)] 平台代码..."
    # 替换为实际编译命令
    # xcodebuild -project OpenIMSDK.xcodeproj -scheme OpenIMSDK -sdk iphonesimulator -arch x86_64 build
    # GOOS=ios GOARCH=amd64 CGO_ENABLED=1 CC=clang go build -o ./bin/ios/x86_64/libopenim-sdk-core.a ./main.go
    echo "✅ [iOS x86_64 (模拟器)] 编译完成！"
    echo "========================================"
}

# ======================== 第二步：检查参数是否完整 ========================
if [ $# -ne 2 ]; then
    echo "❌ 错误：参数数量不正确！"
    echo "✅ 正确用法：sh $0 <操作系统> <架构>"
    echo "📌 支持的平台&架构示例："
    echo "   # Linux 系列"
    echo "   bash $0 Linux x86          bash $0 Linux arm64"
    echo "   # MacOS 系列"
    echo "   bash $0 MacOS arm64        bash $0 MacOS x86_64"
    echo "   # Windows 系列"
    echo "   bash $0 Windows amd64"
    echo "   # Android 系列（核心新增）"
    echo "   bash $0 Android arm64-v8a  bash $0 Android armeabi-v7a"
    echo "   # iOS 系列（核心新增）"
    echo "   bash $0 iOS arm64          bash $0 iOS x86_64"
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