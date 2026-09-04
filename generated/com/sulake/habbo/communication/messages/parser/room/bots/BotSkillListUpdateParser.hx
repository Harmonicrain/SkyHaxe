package com.sulake.habbo.communication.messages.parser.room.bots
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class BotSkillListUpdateParser implements IMessageParser 
    {
        var _botId:Int = 0;
        var _skillList:Array<ASAny>;


        public var skillList(get,never):Array<ASAny>;
function  get_skillList():Array<ASAny>
        {
            return this._skillList;
        }

        public var botId(get,never):Int;
function  get_botId():Int
        {
            return this._botId;
        }

        public function flush():Bool
        {
            this._botId = -1;
            this._skillList = ASCompat.allocArray(0);
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._botId = k.readInteger();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._skillList.push(new BotSkillData(k));
                _local_3++;
            }
            return true;
        }

	public function new() {}
    }

