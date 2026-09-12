package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.users.HabboGroupEntryData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GuildMembershipsMessageParser implements IMessageParser
    {
        var _guilds:Array<ASAny>;

        public function new()
        {
            this._guilds = new Array<ASAny>();
        }

        public function flush():Bool
        {
            this._guilds = [];
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._guilds.push(new HabboGroupEntryData(k));
                _local_3++;
            }
            return true;
        }

        public var guilds(get,never):Array<ASAny>;
public function  get_guilds():Array<ASAny>
        {
            return this._guilds;
        }
    }

