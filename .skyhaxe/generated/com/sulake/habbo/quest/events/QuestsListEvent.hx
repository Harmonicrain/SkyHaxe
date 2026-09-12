package com.sulake.habbo.quest.events
;
    import flash.events.Event;

     class QuestsListEvent extends Event 
    {
        public static inline final QE_QUESTS_SEASONAL= "qe_quests_seasonal";
        public static inline final QUESTS= "qu_quests";

        var _quests:Array<ASAny>;
        var _openWindow:Bool = false;

        public function new(k:String, _arg_2:Array<ASAny>, _arg_3:Bool, _arg_4:Bool=false, _arg_5:Bool=false)
        {
            super(k, _arg_4, _arg_5);
            this._quests = _arg_2;
        }

        public var quests(get,never):Array<ASAny>;
public function  get_quests():Array<ASAny>
        {
            return this._quests;
        }

        public var openWindow(get,never):Bool;
public function  get_openWindow():Bool
        {
            return this._openWindow;
        }
    }

