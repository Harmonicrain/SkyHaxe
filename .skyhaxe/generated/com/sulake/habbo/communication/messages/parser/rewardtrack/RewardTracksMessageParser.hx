package com.sulake.habbo.communication.messages.parser.rewardtrack
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.quest.rewardtrack.data.RewardTrack;

     class RewardTracksMessageParser implements IMessageParser
    {
        var _disabled:Bool = false;
        var _tracks:Array<ASAny>;
        var _reload:Bool = false;

        public function flush():Bool
        {
            this._disabled = false;
            this._tracks = [];
            this._reload = false;
            return true;
        }

        public function parse(wrapper:IMessageDataWrapper):Bool
        {
var i = 0;            var i = 0;
            var count = 0;
            this._tracks = [];
            this._disabled = wrapper.readBoolean();
            count = wrapper.readInteger();
            for (_tmp_ in 0...count)
            {
i= _tmp_;
                this._tracks.push(new RewardTrack(wrapper));
            }
            this._reload = wrapper.readBoolean();
            return true;
        }

        public var disabled(get,never):Bool;
public function  get_disabled():Bool
        {
            return this._disabled;
        }

        public var tracks(get,never):Array<ASAny>;
public function  get_tracks():Array<ASAny>
        {
            return this._tracks;
        }

        public var reload(get,never):Bool;
public function  get_reload():Bool
        {
            return this._reload;
        }

	public function new() {}
    }

