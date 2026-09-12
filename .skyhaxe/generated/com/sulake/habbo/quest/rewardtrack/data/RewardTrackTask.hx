package com.sulake.habbo.quest.rewardtrack.data
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RewardTrackTask
    {
        var _id:String;
        var _actionType:String;
        var _parameter:String;
        var _progressCount:Int = 0;
        var _premium:Bool = false;
        var _levels:Array<ASAny>;

        public function new(wrapper:IMessageDataWrapper)
        {
var i = 0;            var i = 0;
            var levelCount = 0;
            this._levels = [];
            this._id = wrapper.readString();
            this._actionType = wrapper.readString();
            this._parameter = wrapper.readString();
            this._progressCount = wrapper.readInteger();
            this._premium = wrapper.readBoolean();
            levelCount = wrapper.readInteger();
            for (_tmp_ in 0...levelCount)
            {
i= _tmp_;
                this._levels.push(new RewardTrackTaskLevel(wrapper.readInteger(), wrapper.readInteger(), wrapper.readBoolean()));
            }
        }

        public var id(get,never):String;
public function  get_id():String
        {
            return this._id;
        }

        public var actionType(get,never):String;
public function  get_actionType():String
        {
            return this._actionType;
        }

        public var parameter(get,never):String;
public function  get_parameter():String
        {
            return this._parameter;
        }

        
        public var progressCount(get,set):Int;
public function  get_progressCount():Int
        {
            return this._progressCount;
        }
public function  set_progressCount(value:Int):Int        {
            return this._progressCount = value;
        }

        public var premium(get,never):Bool;
public function  get_premium():Bool
        {
            return this._premium;
        }

        public var levels(get,never):Array<ASAny>;
public function  get_levels():Array<ASAny>
        {
            return this._levels;
        }
    }

