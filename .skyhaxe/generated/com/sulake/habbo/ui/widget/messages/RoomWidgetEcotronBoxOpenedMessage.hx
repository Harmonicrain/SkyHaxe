package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetEcotronBoxOpenedMessage extends RoomWidgetMessage 
    {
        public static inline final RWEBOM_ECOTRONBOX_OPENED= "RWEBOM_ECOTRONBOX_OPENED";

        var _itemType:String;
        var _classId:Int = 0;

        public function new(k:String, _arg_2:String, _arg_3:Int)
        {
            super(k);
            this._itemType = _arg_2;
            this._classId = _arg_3;
        }

        public var itemType(get,never):String;
public function  get_itemType():String
        {
            return this._itemType;
        }

        public var classId(get,never):Int;
public function  get_classId():Int
        {
            return this._classId;
        }
    }

