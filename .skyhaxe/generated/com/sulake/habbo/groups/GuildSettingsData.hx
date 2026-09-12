package com.sulake.habbo.groups
;
    import com.sulake.habbo.communication.messages.incoming.users.IGuildData;

     class GuildSettingsData 
    {
        var _guildType:Int = 0;
        var _rightsLevel:Int = 0;
        var _modified:Bool = false;

        public function new(k:IGuildData=null)
        {
            if (k == null)
            {
                return;
            }
            this._guildType = k.guildType;
            this._rightsLevel = k.guildRightsLevel;
        }

        
        public var guildType(get,set):Int;
public function  get_guildType():Int
        {
            return this._guildType;
        }
public function  set_guildType(k:Int):Int        {
            if (k != this._guildType)
            {
                this._modified = true;
            }
            return this._guildType = k;
        }

        
        public var _Str_7959(get,set):Int;
public function  get__Str_7959():Int
        {
            return this._rightsLevel;
        }
public function  set__Str_7959(k:Int):Int        {
            if (k != this._rightsLevel)
            {
                this._modified = true;
            }
            return this._rightsLevel = k;
        }

        public var _Str_22472(get,never):Bool;
public function  get__Str_22472():Bool
        {
            return this._modified;
        }

        public function _Str_15948()
        {
            this._modified = false;
        }
    }

