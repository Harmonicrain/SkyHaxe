package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SharedGlobalPlaceholder
    {
        var _roomId:Int = 0;
        var _roomName:String;
        var _placeholderName:String;

        public function new(k:IMessageDataWrapper)
        {
            WiredMessageDataValidator.requireBytes(k, 8, "SharedGlobalPlaceholder");
            this._roomId = k.readInteger();
            this._roomName = k.readString();
            this._placeholderName = k.readString();
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int { return this._roomId; }
        public var roomName(get,never):String;
public function  get_roomName():String { return this._roomName; }
        public var placeholderName(get,never):String;
public function  get_placeholderName():String { return this._placeholderName; }
    }

