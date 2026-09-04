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
            var i:Int;
            var count:Int;
            this._tracks = [];
            this._disabled = wrapper.readBoolean();
            count = wrapper.readInteger();
            for (i in 0...count)
            {
                this._tracks.push(new RewardTrack(wrapper));
            }
            this._reload = wrapper.readBoolean();
            return true;
        }

        public var disabled(get,never):Bool;
function  get_disabled():Bool
        {
            return this._disabled;
        }

        public var tracks(get,never):Array<ASAny>;
function  get_tracks():Array<ASAny>
        {
            return this._tracks;
        }

        public var reload(get,never):Bool;
function  get_reload():Bool
        {
            return this._reload;
        }

	public function new() {}
    }

