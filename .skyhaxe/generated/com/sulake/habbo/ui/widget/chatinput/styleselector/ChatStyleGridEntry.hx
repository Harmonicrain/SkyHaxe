package com.sulake.habbo.ui.widget.chatinput.styleselector
;
    import flash.display.BitmapData;

     class ChatStyleGridEntry 
    {
        var _id:Int = 0;
        var _bitmap:BitmapData;

        public function new(k:Int, _arg_2:BitmapData)
        {
            this._id = k;
            this._bitmap = _arg_2;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var bitmap(get,never):BitmapData;
public function  get_bitmap():BitmapData
        {
            return this._bitmap;
        }
    }

