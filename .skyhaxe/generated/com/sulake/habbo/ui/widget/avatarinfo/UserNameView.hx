package com.sulake.habbo.ui.widget.avatarinfo
;
     class UserNameView extends AvatarContextInfoView 
    {
        public static inline final _Str_20705:UInt = 0xFF9DBF5A;
        public static inline final _Str_20334= 8000;

        var _objectId:Int = 0;
        var _isGameRoomMode:Bool = false;

        public function new(k:AvatarInfoWidget, _arg_2:Bool=false)
        {
            super(k);
            this._isGameRoomMode = _arg_2;
        }

        public static function setup(k:UserNameView, _arg_2:Int, _arg_3:String, _arg_4:Int, _arg_5:Int, _arg_6:Int, _arg_7:UInt=0xFF9DBF5A, _arg_8:Int=8000)
        {
            k._objectId = _arg_6;
            k._Str_12637 = _arg_8;
            AvatarContextInfoView.setup(k, _arg_2, _arg_3, _arg_4, _arg_5, false);
            k.window.color = _arg_7;
        }


        public var objectId(get,never):Int;
public function  get_objectId():Int
        {
            return this._objectId;
        }

        public var _Str_23492(get,never):Bool;
public function  get__Str_23492():Bool
        {
            return this._isGameRoomMode;
        }

        override public function  get_maximumBlend():Float
        {
            if (this._isGameRoomMode)
            {
                return 0.75;
            }
            return super.maximumBlend;
        }
    }

