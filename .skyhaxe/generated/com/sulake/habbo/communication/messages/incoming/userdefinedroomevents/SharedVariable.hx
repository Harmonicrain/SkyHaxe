package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SharedVariable
    {
        var _roomId:Int = 0;
        var _roomName:String;
        var _wiredVariable:WiredVariable;

        public function new(k:IMessageDataWrapper)
        {
            WiredMessageDataValidator.requireBytes(k, 31, "SharedVariable");
            this._roomId = k.readInteger();
            this._roomName = k.readString();
            this._wiredVariable = new WiredVariable(k);
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int { return this._roomId; }
        public var roomName(get,never):String;
public function  get_roomName():String { return this._roomName; }
        public var wiredVariable(get,never):WiredVariable;
public function  get_wiredVariable():WiredVariable { return this._wiredVariable; }
    }

