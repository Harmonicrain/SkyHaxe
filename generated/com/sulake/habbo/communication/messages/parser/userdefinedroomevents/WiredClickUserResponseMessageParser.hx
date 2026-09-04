package com.sulake.habbo.communication.messages.parser.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     class WiredClickUserResponseMessageParser implements IMessageParser
    {
        var _index:Int = 0;
        var _openMenu:Bool = false;

        public function flush():Bool
        {
            this._index = 0;
            this._openMenu = false;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k.bytesAvailable != 5)
            {
                return false;
            }
            this._index = k.readInteger();
            this._openMenu = k.readBoolean();
            return true;
        }

        public var index(get,never):Int;
function  get_index():Int
        {
            return this._index;
        }

        public var openMenu(get,never):Bool;
function  get_openMenu():Bool
        {
            return this._openMenu;
        }

	public function new() {}
    }

