package com.sulake.habbo.communication.messages.parser.room.pets
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PetTrainingPanelMessageParser implements IMessageParser 
    {
        var _petId:Int = 0;
        var _commands:Array<ASAny>;
        var _enabledCommands:Array<ASAny>;


        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._petId;
        }

        public var commands(get,never):Array<ASAny>;
public function  get_commands():Array<ASAny>
        {
            return this._commands;
        }

        public var enabledCommands(get,never):Array<ASAny>;
public function  get_enabledCommands():Array<ASAny>
        {
            return this._enabledCommands;
        }

        public function flush():Bool
        {
            this._petId = -1;
            this._commands = null;
            this._enabledCommands = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
		
            if (k == null)
            {
                return false;
            }
            this._petId = k.readInteger();
            var _local_2= k.readInteger();
            this._commands = new Array<ASAny>();
            while (_local_2-- > 0)
            {
                this._commands.push(k.readInteger());
            }
            var _local_3= k.readInteger();
            this._enabledCommands = new Array<ASAny>();
            while (_local_3-- > 0)
            {
                this._enabledCommands.push(k.readInteger());
            }
            return true;
        }

	public function new() {}
    }

