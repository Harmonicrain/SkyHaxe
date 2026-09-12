package com.sulake.habbo.communication.messages.parser.talent
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class TalentTrackTask
    {
        public static inline final HABBO_WAY_GRADUATE_1= "ACH_HabboWayGraduate1";
        public static inline final GUIDE_GROUP_MEMBER_1= "ACH_GuideGroupMember1";
        public static inline final SAFETY_QUIZ_GRADUATE_1= "ACH_SafetyQuizGraduate1";
        public static inline final EMAIL_VERIFICATION_1= "ACH_EmailVerification1";
        public static inline final ROOM_ENTRY_1= "ACH_RoomEntry1";
        public static inline final ROOM_ENTRY_2= "ACH_RoomEntry2";
        public static inline final AVATAR_LOOKS_1= "ACH_AvatarLooks1";
        public static inline final GUIDE_ADVERTISEMENT_READER= "ACH_GuideAdvertisementReader1";

        var _achievementId:Int = 0;
        var _requiredLevel:Int = 0;
        var _badgeCode:String;
        var _state:Int = 0;
        var _currentScore:Int = 0;
        var _totalScore:Int = 0;

        public function new(k:IMessageDataWrapper)
        {
            this._achievementId = k.readInteger();
            this._requiredLevel = k.readInteger();
            this._badgeCode = k.readString();
            this._state = k.readInteger();
            this._currentScore = k.readInteger();
            this._totalScore = k.readInteger();
        }

        public var state(get,never):Int;
public function  get_state():Int
        {
            return this._state;
        }

        public var achievementId(get,never):Int;
public function  get_achievementId():Int
        {
            return this._achievementId;
        }

        public var _Str_20240(get,never):Int;
public function  get__Str_20240():Int
        {
            return this._requiredLevel;
        }

        public var badgeCode(get,never):String;
public function  get_badgeCode():String
        {
            return this._badgeCode;
        }

        public var _Str_7605(get,never):Int;
public function  get__Str_7605():Int
        {
            return this._currentScore;
        }

        public var _Str_15676(get,never):Int;
public function  get__Str_15676():Int
        {
            return this._totalScore;
        }

        public function _Str_24120():Bool
        {
            switch (this.badgeCode)
            {
                case HABBO_WAY_GRADUATE_1
                   | SAFETY_QUIZ_GRADUATE_1
                   | EMAIL_VERIFICATION_1
                   | AVATAR_LOOKS_1:
                    return false;
                default:
                    return true;
            }
        }
    }

