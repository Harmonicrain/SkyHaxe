package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetFriendRequestMessage extends RoomWidgetMessage 
    {
        public static inline final RWFRM_ACCEPT= "RWFRM_ACCEPT";
        public static inline final RWFRM_DECLINE= "RWFRM_DECLINE";

        var _requestId:Int = 0;

        public function new(k:String, _arg_2:Int=0)
        {
            super(k);
            this._requestId = _arg_2;
        }

        public var requestId(get,never):Int;
public function  get_requestId():Int
        {
            return this._requestId;
        }
    }

