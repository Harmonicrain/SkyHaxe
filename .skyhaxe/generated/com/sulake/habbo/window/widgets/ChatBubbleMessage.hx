package com.sulake.habbo.window.widgets
;
     class ChatBubbleMessage
    {
        public static inline final TYPE_TEXT= 0;
        public static inline final TYPE_HABBICON= 1;

        var _type:Int = 0;
        var _text:String;
        var _habbiconId:Int = 0;

        public function new(k:Int, _arg_2:String="", _arg_3:Int=0)
        {
            this._type = k;
            this._text = _arg_2;
            this._habbiconId = _arg_3;
        }

        public static function text(k:String):ChatBubbleMessage
        {
            return new ChatBubbleMessage(TYPE_TEXT, ((k == null) ? "" : k));
        }

        public static function habbicon(k:Int):ChatBubbleMessage
        {
            return new ChatBubbleMessage(TYPE_HABBICON, "", k);
        }

        public var type(get,never):Int;
public function  get_type():Int
        {
            return this._type;
        }

        public var textValue(get,never):String;
public function  get_textValue():String
        {
            return this._text;
        }

        public var habbiconId(get,never):Int;
public function  get_habbiconId():Int
        {
            return this._habbiconId;
        }
    }

