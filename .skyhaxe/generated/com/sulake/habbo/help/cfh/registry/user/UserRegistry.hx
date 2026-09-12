package com.sulake.habbo.help.cfh.registry.user
;
    import com.sulake.core.utils.Map;
	import com.sulake.habbo.help.cfh.registry.user.UserRegistryItem;

     class UserRegistry 
    {
        static inline final _Str_18449= 80;

        var _registry:Map;
        var _roomName:String = "";
        var _roomId:Int = 0;
        var _withoutRoomNameList:Array<ASAny>;

        public function new()
        {
            this._registry = new Map();
            this._withoutRoomNameList = new Array<ASAny>();
        }

        public function _Str_20328():Map
        {
            return this._registry;
        }

        public function getEntry(k:Int):UserRegistryItem
        {
            return this._registry.getValue(k);
        }

        public function _Str_19528(k:Int, _arg_2:String)
        {
            this._roomId = k;
            this._roomName = _arg_2;
            if (this._roomName != "")
            {
                this._Str_24907();
            }
        }

        public function _Str_23385(k:Int, _arg_2:String, _arg_3:String="")
        {
            var _local_4:UserRegistryItem = null;
            if (this._registry.getValue(k) != null)
            {
                this._registry.remove(k);
            }
            _local_4 = new UserRegistryItem(k, _arg_2, _arg_3, this._roomId, this._roomName);
            if (this._roomName == "")
            {
                this._withoutRoomNameList.push(k);
            }
            this._registry.add(k, _local_4);
            this._Str_23151();
        }

        function _Str_23151()
        {
            var k = 0;
            while (this._registry.length > (_Str_18449 : UInt))
            {
                k = ASCompat.toInt(this._registry.getKey(0));
                this._registry.remove(k);
            }
        }

        function _Str_24907()
        {
            var k:UserRegistryItem = null;
            while (this._withoutRoomNameList.length > 0)
            {
                k = this._registry.getValue(this._withoutRoomNameList.shift());
                if (((!(k == null)) && (k.roomId == this._roomId)))
                {
                    k.roomName = this._roomName;
                }
            }
        }

        public var roomName(get,never):String;
public function  get_roomName():String
        {
            return this._roomName;
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }
    }

