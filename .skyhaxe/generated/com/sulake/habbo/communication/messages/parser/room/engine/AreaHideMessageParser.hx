package com.sulake.habbo.communication.messages.parser.room.engine
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.room.engine.AreaHideMessageData;

     class AreaHideMessageParser implements IMessageParser
    {
        var _areaHideMessageData:AreaHideMessageData;

        public function flush():Bool
        {
            this._areaHideMessageData = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._areaHideMessageData = new AreaHideMessageData(k);
            return true;
        }

        public var areaHideMessageData(get,never):AreaHideMessageData;
public function  get_areaHideMessageData():AreaHideMessageData
        {
            return this._areaHideMessageData;
        }

	public function new() {}
    }

