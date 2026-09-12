package com.sulake.habbo.session.events
;
    import com.sulake.habbo.session.IRoomSession;

     class RoomSessionPetCommandsUpdateEvent extends RoomSessionEvent 
    {
        public static inline final PET_COMMANDS= "RSPIUE_ENABLED_PET_COMMANDS";

        var _petId:Int = 0;
        var _allCommandIds:Array<ASAny>;
        var _enabledCommandIds:Array<ASAny>;

        public function new(k:IRoomSession, id:Int, commands:Array<ASAny>, enabledCommands:Array<ASAny>, _arg_5:Bool=false, _arg_6:Bool=false)
        {
            super(RoomSessionPetCommandsUpdateEvent.PET_COMMANDS, k, _arg_5, _arg_6);
            this._petId = id;
            this._allCommandIds = commands;
            this._enabledCommandIds = enabledCommands;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._petId;
        }

        public var commands(get,never):Array<ASAny>;
public function  get_commands():Array<ASAny>
        {
            return this._allCommandIds;
        }

        public var enabledCommands(get,never):Array<ASAny>;
public function  get_enabledCommands():Array<ASAny>
        {
            return this._enabledCommandIds;
        }
    }

