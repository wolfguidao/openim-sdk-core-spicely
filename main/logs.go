package main

/*
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
*/
import "C"
import (
	"encoding/json"

	"github.com/openimsdk/openim-sdk-core/v3/open_im_sdk"
)

type UploadLogsCallback struct {
	uuid       string
	methodName string
}

func (u *UploadLogsCallback) OnProgress(current int64, size int64) {
	data := map[string]interface{}{
		"current": current,
		"size":    size,
	}
	jsonData, _ := json.Marshal(data)
	callBack("OnProgress", u.uuid, u.methodName, nil, string(jsonData))
}

//export UploadLogs
func UploadLogs(operationID *C.char, line C.int, ex *C.char, uuid *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "UploadLogs",
	}
	uploadLogsCallback := &UploadLogsCallback{
		uuid:       C.GoString(uuid),
		methodName: "UploadLogsCallback",
	}
	open_im_sdk.UploadLogs(callBack, id, int(line), C.GoString(ex), uploadLogsCallback)
}

//export Logs
func Logs(operationID *C.char, logLevel C.int, file *C.char, line C.int, msgs *C.char, err *C.char, keyAndValue *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "Logs",
	}
	open_im_sdk.Logs(callBack, id, int(logLevel), C.GoString(file), int(line), C.GoString(msgs), C.GoString(err), C.GoString(keyAndValue))
}
