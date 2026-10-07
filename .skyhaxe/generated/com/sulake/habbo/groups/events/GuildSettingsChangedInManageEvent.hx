package com.sulake.habbo.groups.events
;
    import flash.events.Event;

     class GuildSettingsChangedInManageEvent extends Event 
    {
        public static inline final GSCIME_GUILD_VISUAL_SETTINGS_CHANGED= "GSCIME_GUILD_VISUAL_SETTINGS_CHANGED";

        var _guildId:Int = 0;

        public function new(k:String, _arg_2:Int, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(k, _arg_3, _arg_4);
            this._guildId = _arg_2;
        }

        public var guildId(get,never):Int;
public function  get_guildId():Int
        {
            return this._guildId;
        }
    }

