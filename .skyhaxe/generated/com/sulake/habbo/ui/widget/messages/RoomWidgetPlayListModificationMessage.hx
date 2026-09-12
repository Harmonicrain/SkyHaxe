package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetPlayListModificationMessage extends RoomWidgetMessage 
    {
        public static inline final RWPLAM_ADD_TO_PLAYLIST= "RWPLAM_ADD_TO_PLAYLIST";
        public static inline final RWPLAM_REMOVE_FROM_PLAYLIST= "RWPLAM_REMOVE_FROM_PLAYLIST";

        var _diskId:Int = 0;
        var _slotNumber:Int = 0;

        public function new(k:String, _arg_2:Int=-1, _arg_3:Int=-1)
        {
            super(k);
            this._slotNumber = _arg_2;
            this._diskId = _arg_3;
        }

        public var diskId(get,never):Int;
public function  get_diskId():Int
        {
            return this._diskId;
        }

        public var _Str_20440(get,never):Int;
public function  get__Str_20440():Int
        {
            return this._slotNumber;
        }
    }

