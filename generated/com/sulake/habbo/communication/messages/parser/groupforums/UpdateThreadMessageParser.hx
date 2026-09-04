package com.sulake.habbo.communication.messages.parser.groupforums
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class UpdateThreadMessageParser implements IMessageParser
    {
        var _groupId:Int = 0;
        var _thread:GuildForumThread;


        public var groupId(get,never):Int;
function  get_groupId():Int
        {
            return this._groupId;
        }

        public var thread(get,never):GuildForumThread;
function  get_thread():GuildForumThread
        {
            return this._thread;
        }

        public function flush():Bool
        {
            this._groupId = -1;
            this._thread = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._groupId = k.readInteger();
            this._thread = GuildForumThread.parse(k);
            return true;
        }

	public function new() {}
    }

