package com.sulake.habbo.communication.messages.parser.roomsettings
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ShowEnforceRoomCategoryDialogParser implements IMessageParser
    {
        var _selectionType:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._selectionType = k.readInteger();
            return true;
        }

        public var selectionType(get,never):Int;
public function  get_selectionType():Int
        {
            return this._selectionType;
        }

	public function new() {}
    }

