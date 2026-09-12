package com.sulake.habbo.communication.messages.parser.inventory.achievements
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.inventory.achievements.Achievement;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class AchievementsParser implements IMessageParser 
    {
        var _achievements:Array<ASAny>;
        var _Str_19269:String;


        public function flush():Bool
        {
            this._achievements = new Array<ASAny>();
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._achievements = new Array<ASAny>();
            var count= k.readInteger();
            var index = 0;
            while (index < count)
            {
                this._achievements.push(new Achievement(k));
                index++;
            }
            this._Str_19269 = k.readString();
            return true;
        }

        public var achievements(get,never):Array<ASAny>;
public function  get_achievements():Array<ASAny>
        {
            return this._achievements;
        }

        public var defaultCategory(get,never):String;
public function  get_defaultCategory():String
        {
            return this._Str_19269;
        }
public function new(){}
    }

