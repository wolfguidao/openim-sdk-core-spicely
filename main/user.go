package main

/*
#include <stdio.h>
*/
import "C"
import "github.com/openimsdk/openim-sdk-core/v3/open_im_sdk"

//export GetUsersInfo
func GetUsersInfo(operationID *C.char, userIDList *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "GetUsersInfo",
	}
	open_im_sdk.GetUsersInfo(callBack, id, C.GoString(userIDList))
}

//export GetUsersInfoFromSrv
func GetUsersInfoFromSrv(operationID *C.char, userIDList *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "GetUsersInfoFromSrv",
	}
	open_im_sdk.GetUsersInfo(callBack, id, C.GoString(userIDList))
}

//export SetSelfInfo
func SetSelfInfo(operationID *C.char, userInfo *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "SetSelfInfo",
	}
	open_im_sdk.SetSelfInfo(callBack, id, C.GoString(userInfo))
}

//export GetSelfUserInfo
func GetSelfUserInfo(operationID *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "GetSelfUserInfo",
	}
	open_im_sdk.GetSelfUserInfo(callBack, id)
}

//export SubscribeUsersStatus
func SubscribeUsersStatus(operationID *C.char, userIDs *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "SubscribeUsersStatus",
	}
	open_im_sdk.SubscribeUsersStatus(callBack, id, C.GoString(userIDs))
}

//export UnsubscribeUsersStatus
func UnsubscribeUsersStatus(operationID *C.char, userIDs *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "UnsubscribeUsersStatus",
	}
	open_im_sdk.UnsubscribeUsersStatus(callBack, id, C.GoString(userIDs))
}

//export GetSubscribeUsersStatus
func GetSubscribeUsersStatus(operationID *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "GetSubscribeUsersStatus",
	}
	open_im_sdk.GetSubscribeUsersStatus(callBack, id)
}
