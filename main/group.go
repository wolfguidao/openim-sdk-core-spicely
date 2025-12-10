package main

/*
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
*/
import "C"
import "github.com/openimsdk/openim-sdk-core/v3/open_im_sdk"

//export CreateGroup
func CreateGroup(operationID *C.char, groupReqInfo *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "CreateGroup",
	}
	open_im_sdk.CreateGroup(callBack, id, C.GoString(groupReqInfo))
}

//export JoinGroup
func JoinGroup(operationID *C.char, groupID *C.char, reqMsg *C.char, joinSource C.int32_t, ex *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "JoinGroup",
	}
	open_im_sdk.JoinGroup(callBack, id, C.GoString(groupID), C.GoString(reqMsg), int32(joinSource), C.GoString(ex))
}

//export InviteUserToGroup
func InviteUserToGroup(operationID *C.char, groupID *C.char, reason *C.char, userIDList *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "InviteUserToGroup",
	}
	open_im_sdk.InviteUserToGroup(callBack, id, C.GoString(groupID), C.GoString(reason), C.GoString(userIDList))
}

//export GetJoinedGroupList
func GetJoinedGroupList(operationID *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "GetJoinedGroupList",
	}
	open_im_sdk.GetJoinedGroupList(callBack, id)
}

//export getJoinedGroupListPage
func getJoinedGroupListPage(operationID *C.char, offset C.int32_t, count C.int32_t) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "getJoinedGroupListPage",
	}
	open_im_sdk.GetJoinedGroupListPage(callBack, id, int32(offset), int32(count))
}

//export SearchGroups
func SearchGroups(operationID *C.char, searchParam *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "SearchGroups",
	}
	open_im_sdk.SearchGroups(callBack, id, C.GoString(searchParam))
}

//export GetSpecifiedGroupsInfo
func GetSpecifiedGroupsInfo(operationID *C.char, groupIDList *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "GetSpecifiedGroupsInfo",
	}
	open_im_sdk.GetSpecifiedGroupsInfo(callBack, id, C.GoString(groupIDList))
}

//export SetGroupInfo
func SetGroupInfo(operationID *C.char, groupInfo *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "SetGroupInfo",
	}
	open_im_sdk.SetGroupInfo(callBack, id, C.GoString(groupInfo))
}

//export GetGroupApplicationListAsRecipient
func GetGroupApplicationListAsRecipient(operationID *C.char, req *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "GetGroupApplicationListAsRecipient",
	}
	open_im_sdk.GetGroupApplicationListAsRecipient(callBack, id, C.GoString(req))
}

//export GetGroupApplicationListAsApplicant
func GetGroupApplicationListAsApplicant(operationID *C.char, req *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "GetGroupApplicationListAsApplicant",
	}
	open_im_sdk.GetGroupApplicationListAsApplicant(callBack, id, C.GoString(req))
}

//export AcceptGroupApplication
func AcceptGroupApplication(operationID *C.char, groupID *C.char, fromUserID *C.char, handleMsg *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "AcceptGroupApplication",
	}
	open_im_sdk.AcceptGroupApplication(callBack, id, C.GoString(groupID), C.GoString(fromUserID), C.GoString(handleMsg))
}

//export RefuseGroupApplication
func RefuseGroupApplication(operationID *C.char, groupID *C.char, fromUserID *C.char, handleMsg *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "RefuseGroupApplication",
	}
	open_im_sdk.RefuseGroupApplication(callBack, id, C.GoString(groupID), C.GoString(fromUserID), C.GoString(handleMsg))
}

//export GetGroupMemberList
func GetGroupMemberList(operationID *C.char, groupID *C.char, filter C.int32_t, offset C.int32_t, count C.int32_t) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "GetGroupMemberList",
	}
	open_im_sdk.GetGroupMemberList(callBack, id, C.GoString(groupID), int32(filter), int32(offset), int32(count))
}

//export GetSpecifiedGroupMembersInfo
func GetSpecifiedGroupMembersInfo(operationID *C.char, groupID *C.char, userIDList *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "GetSpecifiedGroupMembersInfo",
	}
	open_im_sdk.GetSpecifiedGroupMembersInfo(callBack, id, C.GoString(groupID), C.GoString(userIDList))
}

//export SearchGroupMembers
func SearchGroupMembers(operationID *C.char, searchParam *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "SearchGroupMembers",
	}
	open_im_sdk.SearchGroupMembers(callBack, id, C.GoString(searchParam))
}

//export SetGroupMemberInfo
func SetGroupMemberInfo(operationID *C.char, groupMemberInfo *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "SetGroupMemberInfo",
	}
	open_im_sdk.SetGroupMemberInfo(callBack, id, C.GoString(groupMemberInfo))
}

//export GetGroupMemberOwnerAndAdmin
func GetGroupMemberOwnerAndAdmin(operationID *C.char, groupID *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "GetGroupMemberOwnerAndAdmin",
	}
	open_im_sdk.GetGroupMemberOwnerAndAdmin(callBack, id, C.GoString(groupID))
}

//export GetGroupMemberListByJoinTimeFilter
func GetGroupMemberListByJoinTimeFilter(operationID *C.char, groupID *C.char, offset C.int32_t, count C.int32_t, joinTimeBegin C.int64_t, joinTimeEnd C.int64_t, filterUserIDList *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "GetGroupMemberListByJoinTimeFilter",
	}
	open_im_sdk.GetGroupMemberListByJoinTimeFilter(callBack, id, C.GoString(groupID), int32(offset), int32(count), int64(joinTimeBegin), int64(joinTimeEnd), C.GoString(filterUserIDList))
}

//export KickGroupMember
func KickGroupMember(operationID *C.char, groupID *C.char, reason *C.char, userIDList *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "KickGroupMember",
	}
	open_im_sdk.KickGroupMember(callBack, id, C.GoString(groupID), C.GoString(reason), C.GoString(userIDList))
}

//export ChangeGroupMemberMute
func ChangeGroupMemberMute(operationID *C.char, groupID *C.char, userID *C.char, mutedSeconds C.int) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "ChangeGroupMute",
	}
	open_im_sdk.ChangeGroupMemberMute(callBack, id, C.GoString(groupID), C.GoString(userID), int(mutedSeconds))
}

//export ChangeGroupMute
func ChangeGroupMute(operationID *C.char, groupID *C.char, isMute C.bool) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "ChangeGroupMute",
	}
	open_im_sdk.ChangeGroupMute(callBack, id, C.GoString(groupID), bool(isMute))
}

//export TransferGroupOwner
func TransferGroupOwner(operationID *C.char, groupID *C.char, newOwnerUserID *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "TransferGroupOwner",
	}
	open_im_sdk.TransferGroupOwner(callBack, id, C.GoString(groupID), C.GoString(newOwnerUserID))
}

//export DismissGroup
func DismissGroup(operationID *C.char, groupID *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "DismissGroup",
	}
	open_im_sdk.DismissGroup(callBack, id, C.GoString(groupID))
}

//export GetUsersInGroup
func GetUsersInGroup(operationID *C.char, groupID *C.char, userIDList *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "GetUsersInGroup",
	}
	open_im_sdk.GetUsersInGroup(callBack, id, C.GoString(groupID), C.GoString(userIDList))
}

//export IsJoinGroup
func IsJoinGroup(operationID *C.char, groupID *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "IsJoinGroup",
	}
	open_im_sdk.IsJoinGroup(callBack, id, C.GoString(groupID))
}

//export QuitGroup
func QuitGroup(operationID *C.char, groupID *C.char) {
	id := C.GoString(operationID)
	callBack := &BaseListener{
		operationID: id,
		methodName:  "QuitGroup",
	}
	open_im_sdk.QuitGroup(callBack, id, C.GoString(groupID))
}
