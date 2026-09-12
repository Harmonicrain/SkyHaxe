package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetUserActionMessage extends RoomWidgetMessage 
    {
        public static inline final RWUAM_WHISPER_USER= "RWUAM_WHISPER_USER";
        public static inline final RWUAM_IGNORE_USER= "RWUAM_IGNORE_USER";
        public static inline final RWUAM_IGNORE_USER_BUBBLE= "RWUAM_IGNORE_USER_BUBBLE";
        public static inline final RWUAM_UNIGNORE_USER= "RWUAM_UNIGNORE_USER";
        public static inline final RWUAM_KICK_USER= "RWUAM_KICK_USER";
        public static inline final RWUAM_BAN_USER_HOUR= "RWUAM_BAN_USER_HOUR";
        public static inline final RWUAM_BAN_USER_DAY= "RWUAM_BAN_USER_DAY";
        public static inline final RWUAM_BAN_USER_PERM= "RWUAM_BAN_USER_PERM";
        public static inline final MUTE_USER_2MIN= "RWUAM_MUTE_USER_2MIN";
        public static inline final MUTE_USER_5MIN= "RWUAM_MUTE_USER_5MIN";
        public static inline final MUTE_USER_10MIN= "RWUAM_MUTE_USER_10MIN";
        public static inline final RWUAM_SEND_FRIEND_REQUEST= "RWUAM_SEND_FRIEND_REQUEST";
        public static inline final RWUAM_RESPECT_USER= "RWUAM_RESPECT_USER";
        public static inline final RWUAM_GIVE_RIGHTS= "RWUAM_GIVE_RIGHTS";
        public static inline final RWUAM_TAKE_RIGHTS= "RWUAM_TAKE_RIGHTS";
        public static inline final RWUAM_START_TRADING= "RWUAM_START_TRADING";
        public static inline final RWUAM_OPEN_HOME_PAGE= "RWUAM_OPEN_HOME_PAGE";
        public static inline final RWUAM_REPORT= "RWUAM_REPORT";
        public static inline final RWUAM_PICKUP_PET= "RWUAM_PICKUP_PET";
        public static inline final RWUAM_MOUNT_PET= "RWUAM_MOUNT_PET";
        public static inline final RWUAM_TOGGLE_PET_RIDING_PERMISSION= "RWUAM_TOGGLE_PET_RIDING_PERMISSION";
        public static inline final RWUAM_TOGGLE_PET_BREEDING_PERMISSION= "RWUAM_TOGGLE_PET_BREEDING_PERMISSION";
        public static inline final RWUAM_DISMOUNT_PET= "RWUAM_DISMOUNT_PET";
        public static inline final RWUAM_SADDLE_OFF= "RWUAM_SADDLE_OFF";
        public static inline final RWUAM_TRAIN_PET= "RWUAM_TRAIN_PET";
        public static inline final RESPECT_PET= " RWUAM_RESPECT_PET";
        public static inline final RWUAM_TREAT_PET= "RWUAM_TREAT_PET";
        public static inline final RWUAM_REQUEST_PET_UPDATE= "RWUAM_REQUEST_PET_UPDATE";
        public static inline final RWUAM_START_NAME_CHANGE= "RWUAM_START_NAME_CHANGE";
        public static inline final RWUAM_PASS_CARRY_ITEM= "RWUAM_PASS_CARRY_ITEM";
        public static inline final RWUAM_DROP_CARRY_ITEM= "RWUAM_DROP_CARRY_ITEM";
        public static inline final RWUAM_GIVE_CARRY_ITEM_TO_PET= "RWUAM_GIVE_CARRY_ITEM_TO_PET";
        public static inline final RWUAM_GIVE_WATER_TO_PET= "RWUAM_GIVE_WATER_TO_PET";
        public static inline final RWUAM_GIVE_LIGHT_TO_PET= "RWUAM_GIVE_LIGHT_TO_PET";
        public static inline final RWUAM_REQUEST_BREED_PET= "RWUAM_REQUEST_BREED_PET";
        public static inline final RWUAM_HARVEST_PET= "RWUAM_HARVEST_PET";
        public static inline final RWUAM_REVIVE_PET= "RWUAM_REVIVE_PET";
        public static inline final RWUAM_COMPOST_PLANT= "RWUAM_COMPOST_PLANT";
        public static inline final RWUAM_GET_BOT_INFO= "RWUAM_GET_BOT_INFO";
        public static inline final RWUAM_REPORT_CFH_OTHER= "RWUAM_REPORT_CFH_OTHER";
        public static inline final RWUAM_AMBASSADOR_ALERT_USER= "RWUAM_AMBASSADOR_ALERT_USER";
        public static inline final RWUAM_AMBASSADOR_KICK_USER= "RWUAM_AMBASSADOR_KICK_USER";
        public static inline final AMBASSADOR_MUTE_USER_2MIN= "RWUAM_AMBASSADOR_MUTE_2MIN";
        public static inline final AMBASSADOR_MUTE_USER_10MIN= "RWUAM_AMBASSADOR_MUTE_10MIN";
        public static inline final AMBASSADOR_MUTE_USER_60MIN= "RWUAM_AMBASSADOR_MUTE_60MIN";
        public static inline final AMBASSADOR_MUTE_USER_18HOUR= "RWUAM_AMBASSADOR_MUTE_18HOUR";
        public static inline final GROUP_WHISPER= "RWUAM_GROUP_WHISPER";
        public static inline final RWUAM_WIRED_INSPECT= "RWUAM_WIRED_INSPECT";
        public static inline final RWUAM_WIRED_INSPECT_BOT= "RWUAM_WIRED_INSPECT_BOT";
        public static inline final RWUAM_WIRED_INSPECT_PET= "RWUAM_WIRED_INSPECT_PET";

        var _userId:Int = 0;

        public function new(k:String, _arg_2:Int=0)
        {
            super(k);
            this._userId = _arg_2;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }
    }

