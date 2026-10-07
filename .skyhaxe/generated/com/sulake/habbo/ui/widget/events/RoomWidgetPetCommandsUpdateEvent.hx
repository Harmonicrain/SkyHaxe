package com.sulake.habbo.ui.widget.events
;
     class RoomWidgetPetCommandsUpdateEvent extends RoomWidgetUpdateEvent 
    {
        public static inline final PET_COMMANDS= "RWPCUE_PET_COMMANDS";
        public static inline final OPEN_PET_TRAINING= "RWPCUE_OPEN_PET_TRAINING";
        public static inline final CLOSE_PET_TRAINING= "RWPCUE_CLOSE_PET_TRAINING";

        var _id:Int = 0;
        var _allCommands:Array<ASAny>;
        var _enabledCommands:Array<ASAny>;

        public function new(k:Int, commands:Array<ASAny>, enabledCommands:Array<ASAny>, _arg_4:Bool=false, _arg_5:Bool=false)
        {
            super(RoomWidgetPetCommandsUpdateEvent.PET_COMMANDS, _arg_4, _arg_5);
            this._id = k;
            this._allCommands = commands;
            this._enabledCommands = enabledCommands;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var commands(get,never):Array<ASAny>;
public function  get_commands():Array<ASAny>
        {
            return this._allCommands;
        }

        public var enabledCommands(get,never):Array<ASAny>;
public function  get_enabledCommands():Array<ASAny>
        {
            return this._enabledCommands;
        }
    }

