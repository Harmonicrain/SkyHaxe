package com.sulake.habbo.ui.widget.events
;
     class _Str_5375 extends RoomWidgetUpdateEvent 
    {
        public static inline final RWRBSLUE_SKILL_LIST= "RWRBSLUE_SKILL_LIST";

        var _botId:Int = 0;
        var _Str_6548:Array<ASAny>;

        public function new(k:Int, _arg_2:Array<ASAny>, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(RWRBSLUE_SKILL_LIST, _arg_3, _arg_4);
            this._botId = k;
            this._Str_6548 = _arg_2;
        }

        public var _Str_10833(get,never):Array<ASAny>;
public function  get__Str_10833():Array<ASAny>
        {
            return this._Str_6548;
        }

        public var botId(get,never):Int;
public function  get_botId():Int
        {
            return this._botId;
        }
    }

