package main

/*
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "openim_sdk_ffi.h"


static void callOnMethodChannel(Openim_Listener listener, Dart_Port_DL port, char *message) {
    listener.onMethodChannel(port, message);
}


*/
import "C"
import (
	"github.com/openimsdk/openim-sdk-core/v3/open_im_sdk"
	"github.com/openimsdk/openim-sdk-core/v3/pkg/utils"
)

var openIMListener C.Openim_Listener
var main_isolate_send_port C.Dart_Port_DL
var initSDK = false

func initListener() {
	groupListener := &GroupListener{}
	open_im_sdk.SetGroupListener(groupListener)

	conversationListener := &ConversationListener{}
	open_im_sdk.SetConversationListener(conversationListener)

	advancedMsgListener := &AdvancedMsgListener{}
	open_im_sdk.SetAdvancedMsgListener(advancedMsgListener)

	// batchMsgListener := &BatchMsgListener{}
	// open_im_sdk.SetBatchMsgListener(batchMsgListener)

	userListener := &UserListener{}
	open_im_sdk.SetUserListener(userListener)

	customBusinessListener := &CustomBusinessListener{}
	open_im_sdk.SetCustomBusinessListener(customBusinessListener)

	friendshipListener := &FriendshipListener{}
	open_im_sdk.SetFriendListener(friendshipListener)

	messageKvInfoListener := &MessageKvInfoListener{}
	open_im_sdk.SetMessageKvInfoListener(messageKvInfoListener)

}

type CallOnMethod struct {
	OperationID    interface{} `json:"operationID" binding:"required"`
	CallMethodName interface{} `json:"callMethodName"`
	ErrCode        interface{} `json:"errCode"`
	Message        interface{} `json:"data"`
	MethodName     string      `json:"method"`
}

func callBack(methodName string, operationID interface{}, callMethodName interface{}, errCode interface{}, message interface{}) {
	var msg = &CallOnMethod{
		MethodName:     methodName,
		OperationID:    operationID,
		CallMethodName: callMethodName,
		ErrCode:        errCode,
		Message:        message,
	}
	C.callOnMethodChannel(openIMListener, main_isolate_send_port, C.CString(utils.StructToJsonString(msg)))
}

type OnConnListener struct{}

func (c *OnConnListener) OnConnecting() {
	callBack("OnConnecting", nil, nil, nil, nil)
}

func (c *OnConnListener) OnConnectSuccess() {
	callBack("OnConnectSuccess", nil, nil, nil, nil)
}

func (c *OnConnListener) OnConnectFailed(errCode int32, errMsg string) {
	callBack("OnConnectFailed", nil, nil, errCode, errMsg)
}

func (c *OnConnListener) OnKickedOffline() {
	callBack("OnKickedOffline", nil, nil, nil, nil)
}

func (c *OnConnListener) OnUserTokenExpired() {
	callBack("OnUserTokenExpired", nil, nil, nil, nil)
}

func (c *OnConnListener) OnUserTokenInvalid(errMsg string) {
	callBack("OnUserTokenInvalid", nil, nil, nil, errMsg)
}

type BaseListener struct {
	operationID string
	methodName  string
}

func (b BaseListener) OnError(errCode int32, errMsg string) {
	callBack("OnError", b.operationID, b.methodName, errCode, errMsg)
}

func (b BaseListener) OnSuccess(data string) {
	callBack("OnSuccess", b.operationID, b.methodName, nil, data)
}

type SendMsgCallBackListener struct {
	operationID string
	methodName  string
	clientMsgID string
}

func (c SendMsgCallBackListener) OnProgress(progress int) {
	callBack("OnProgress", c.operationID, c.methodName, progress, c.clientMsgID)
}

func (c SendMsgCallBackListener) OnError(errCode int32, errMsg string) {
	callBack("OnError", c.operationID, c.methodName, errCode, errMsg)
}

func (c SendMsgCallBackListener) OnSuccess(data string) {
	callBack("OnSuccess", c.operationID, c.methodName, nil, data)
}

type UserListener struct{}

func (o UserListener) OnSelfInfoUpdated(userInfo string) {
	callBack("OnSelfInfoUpdated", nil, nil, nil, userInfo)
}

func (o UserListener) OnUserStatusChanged(statusMap string) {
	callBack("OnUserStatusChanged", nil, nil, nil, statusMap)
}

func (o UserListener) OnUserCommandAdd(userCommand string) {
	callBack("OnUserCommandAdd", nil, nil, nil, userCommand)
}

func (o UserListener) OnUserCommandDelete(userCommand string) {
	callBack("OnUserCommandDelete", nil, nil, nil, userCommand)
}

func (o UserListener) OnUserCommandUpdate(userCommand string) {
	callBack("OnUserCommandUpdate", nil, nil, nil, userCommand)
}

type AdvancedMsgListener struct{}

func (a AdvancedMsgListener) OnRecvNewMessage(message string) {
	callBack("OnRecvNewMessage", nil, nil, nil, message)
}

func (a AdvancedMsgListener) OnRecvC2CReadReceipt(msgReceiptList string) {
	callBack("OnRecvC2CReadReceipt", nil, nil, nil, msgReceiptList)
}

func (a AdvancedMsgListener) OnNewRecvMessageRevoked(messageRevoked string) {
	callBack("OnNewRecvMessageRevoked", nil, nil, nil, messageRevoked)
}

func (a AdvancedMsgListener) OnRecvOfflineNewMessage(messageList string) {
	callBack("OnRecvOfflineNewMessage", nil, nil, nil, messageList)
}

func (a AdvancedMsgListener) OnMsgDeleted(message string) {
	callBack("OnMsgDeleted", nil, nil, nil, message)
}

func (a AdvancedMsgListener) OnRecvOnlineOnlyMessage(message string) {
	callBack("OnRecvOnlineOnlyMessage", nil, nil, nil, message)
}
func (a AdvancedMsgListener) OnMsgEdited(message string) {
	callBack("OnMsgEdited", nil, nil, nil, message)
}

type FriendshipListener struct{}

func (f FriendshipListener) OnFriendApplicationAdded(friendApplication string) {
	callBack("OnFriendApplicationAdded", nil, nil, nil, friendApplication)
}

func (f FriendshipListener) OnFriendApplicationDeleted(friendApplication string) {
	callBack("OnFriendApplicationDeleted", nil, nil, nil, friendApplication)
}

func (f FriendshipListener) OnFriendApplicationAccepted(friendApplication string) {
	callBack("OnFriendApplicationAccepted", nil, nil, nil, friendApplication)
}

func (f FriendshipListener) OnFriendApplicationRejected(friendApplication string) {
	callBack("OnFriendApplicationRejected", nil, nil, nil, friendApplication)
}

func (f FriendshipListener) OnFriendAdded(friendInfo string) {
	callBack("OnFriendAdded", nil, nil, nil, friendInfo)
}

func (f FriendshipListener) OnFriendDeleted(friendInfo string) {
	callBack("OnFriendDeleted", nil, nil, nil, friendInfo)
}

func (f FriendshipListener) OnFriendInfoChanged(friendInfo string) {
	callBack("OnFriendInfoChanged", nil, nil, nil, friendInfo)
}

func (f FriendshipListener) OnBlackAdded(blackInfo string) {
	callBack("OnBlackAdded", nil, nil, nil, blackInfo)
}

func (f FriendshipListener) OnBlackDeleted(blackInfo string) {
	callBack("OnBlackDeleted", nil, nil, nil, blackInfo)
}

type GroupListener struct{}

func (gl GroupListener) OnJoinedGroupAdded(groupInfo string) {
	callBack("OnJoinedGroupAdded", nil, nil, nil, groupInfo)
}
func (gl GroupListener) OnJoinedGroupDeleted(groupInfo string) {
	callBack("OnJoinedGroupDeleted", nil, nil, nil, groupInfo)
}
func (gl GroupListener) OnGroupMemberAdded(groupMemberInfo string) {
	callBack("OnGroupMemberAdded", nil, nil, nil, groupMemberInfo)
}

func (gl GroupListener) OnGroupMemberDeleted(groupMemberInfo string) {
	callBack("OnGroupMemberDeleted", nil, nil, nil, groupMemberInfo)
}

func (gl GroupListener) OnGroupApplicationAdded(groupApplication string) {
	callBack("OnGroupApplicationAdded", nil, nil, nil, groupApplication)
}
func (gl GroupListener) OnGroupApplicationDeleted(groupApplication string) {
	callBack("OnGroupApplicationDeleted", nil, nil, nil, groupApplication)
}
func (gl GroupListener) OnGroupInfoChanged(groupInfo string) {
	callBack("OnGroupInfoChanged", nil, nil, nil, groupInfo)
}
func (gl GroupListener) OnGroupDismissed(groupInfo string) {
	callBack("OnGroupDismissed", nil, nil, nil, groupInfo)
}
func (gl GroupListener) OnGroupMemberInfoChanged(groupMemberInfo string) {
	callBack("OnGroupMemberInfoChanged", nil, nil, nil, groupMemberInfo)
}
func (gl GroupListener) OnGroupApplicationAccepted(groupApplication string) {
	callBack("OnGroupApplicationAccepted", nil, nil, nil, groupApplication)
}
func (gl GroupListener) OnGroupApplicationRejected(groupApplication string) {
	callBack("OnGroupApplicationRejected", nil, nil, nil, groupApplication)
}

type BatchMsgListener struct{}

func (bml BatchMsgListener) OnRecvNewMessages(messageList string) {
	callBack("OnRecvNewMessages", nil, nil, nil, messageList)
}

func (bml BatchMsgListener) OnRecvOfflineNewMessages(messageList string) {
	callBack("OnRecvOfflineNewMessages", nil, nil, nil, messageList)
}

type MessageKvInfoListener struct{}

func (mkl MessageKvInfoListener) OnMessageKvInfoChanged(messageChangedList string) {
	callBack("OnMessageKvInfoChanged", nil, nil, nil, messageChangedList)
}

type ConversationListener struct{}

func (c ConversationListener) OnSyncServerStart(reinstalled bool) {
	callBack("OnSyncServerStart", nil, nil, reinstalled, nil)
}

func (c ConversationListener) OnSyncServerFinish(reinstalled bool) {
	callBack("OnSyncServerFinish", nil, nil, reinstalled, nil)
}

func (c ConversationListener) OnSyncServerProgress(progress int) {
	callBack("OnSyncServerProgress", nil, nil, progress, nil)
}

func (c ConversationListener) OnSyncServerFailed(reinstalled bool) {
	callBack("OnSyncServerFailed", nil, nil, reinstalled, nil)
}

func (c ConversationListener) OnNewConversation(conversationList string) {
	callBack("OnNewConversation", nil, nil, nil, conversationList)
}

func (c ConversationListener) OnConversationChanged(conversationList string) {
	callBack("OnConversationChanged", nil, nil, nil, conversationList)
}

func (c ConversationListener) OnTotalUnreadMessageCountChanged(totalUnreadCount int32) {
	callBack("OnTotalUnreadMessageCountChanged", nil, nil, totalUnreadCount, nil)
}
func (c ConversationListener) OnConversationUserInputStatusChanged(change string) {
	callBack("OnConversationUserInputStatusChanged", nil, nil, nil, change)
}

type CustomBusinessListener struct{}

func (c CustomBusinessListener) OnRecvCustomBusinessMessage(businessMessage string) {
	callBack("OnRecvCustomBusinessMessage", nil, nil, nil, businessMessage)
}

//export GetSdkVersion
func GetSdkVersion() *C.char {
	return C.CString(open_im_sdk.GetSdkVersion())
}

//export InitSDK
func InitSDK(imListener C.Openim_Listener, port C.Dart_Port_DL, operationID *C.char, config *C.char) C.bool {
	if initSDK {
		main_isolate_send_port = port
		return C.bool(true)
	}
	initSDK = true
	openIMListener = imListener
	main_isolate_send_port = port
	listener := &OnConnListener{}
	status := C.bool(open_im_sdk.InitSDK(listener, C.GoString(operationID), C.GoString(config)))
	initListener()
	return status
}

//export Login
func Login(operationID *C.char, userID *C.char, token *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "Login",
	}
	open_im_sdk.Login(callBack, id, C.GoString(userID), C.GoString(token))
}

//export Logout
func Logout(operationID *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "Logout",
	}
	open_im_sdk.Logout(callBack, id)
}

//export SetAppBackgroundStatus
func SetAppBackgroundStatus(operationID *C.char, isBackground C.bool) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "SetAppBackgroundStatus",
	}
	open_im_sdk.SetAppBackgroundStatus(callBack, id, bool(isBackground))
}

//export NetworkStatusChanged
func NetworkStatusChanged(operationID *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "NetworkStatusChanged",
	}
	open_im_sdk.NetworkStatusChanged(callBack, id)
}

//export GetLoginStatus
func GetLoginStatus(operationID *C.char) C.int {
	id := C.GoString(operationID)
	return C.int(open_im_sdk.GetLoginStatus(id))

}

//export GetLoginUserID
func GetLoginUserID() *C.char {
	return C.CString(open_im_sdk.GetLoginUserID())
}

func main() {}
