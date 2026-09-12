package com.sulake.habbo.communication.messages.incoming.callforhelp
;
    import com.sulake.habbo.communication.messages.incoming.moderation.INamed;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CfhSanctionTypeData implements INamed
    {
        var _name:String;
        var _sanctionLengthInHours:Int = 0;
        var _probationDays:Int = 0;
        var _avatarOnly:Bool = false;
        var _tradeLockInfo:String = "";
        var _machineBanInfo:String = "";

        public function new(k:IMessageDataWrapper)
        {
            this._name = k.readString();
            this._sanctionLengthInHours = k.readInteger();
            this._probationDays = k.readInteger();
            this._avatarOnly = k.readBoolean();
            if (k.bytesAvailable != 0)
            {
                this._tradeLockInfo = k.readString();
            }
            if (k.bytesAvailable != 0)
            {
                this._machineBanInfo = k.readString();
            }
            Logger.log([((((((((("READ CFH SANCTION TYPE: " + this._name) + ", length: ") + Std.string(this._sanctionLengthInHours)) + ", avatar only: ") + Std.string(this._avatarOnly)) + ", trade lock info: ") + this._tradeLockInfo) + ", machine ban info: ") + this._machineBanInfo)]);
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var sanctionLengthInHours(get,never):Int;
public function  get_sanctionLengthInHours():Int
        {
            return this._sanctionLengthInHours;
        }

        public var avatarOnly(get,never):Bool;
public function  get_avatarOnly():Bool
        {
            return this._avatarOnly;
        }

        public var tradeLockInfo(get,never):String;
public function  get_tradeLockInfo():String
        {
            return this._tradeLockInfo;
        }

        public var machineBanInfo(get,never):String;
public function  get_machineBanInfo():String
        {
            return this._machineBanInfo;
        }
    }

