package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetSelectOutfitMessage extends RoomWidgetMessage 
    {
        public static inline final SELECT_OUTFIT= "select_outfit";

        var _outfitId:Int = 0;

        public function new(k:Int)
        {
            super(SELECT_OUTFIT);
            this._outfitId = k;
        }

        public var _Str_26349(get,never):Int;
public function  get__Str_26349():Int
        {
            return this._outfitId;
        }
    }

