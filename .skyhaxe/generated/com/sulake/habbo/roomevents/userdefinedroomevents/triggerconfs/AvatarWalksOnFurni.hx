package com.sulake.habbo.roomevents.userdefinedroomevents.triggerconfs
;
    import com.sulake.habbo.roomevents.userdefinedroomevents.UserDefinedRoomEventsCtrl;

     class AvatarWalksOnFurni extends WiredTrigger 
    {


        override public function  get_code():Int
        {
            return WiredTriggerType.AVATAR_WALKS_ON_FURNI;
        }

        override public function  get_requiresFurni():Int
        {
            return UserDefinedRoomEventsCtrl._Str_4991;
        }
public function new(){	super();
}
    }

