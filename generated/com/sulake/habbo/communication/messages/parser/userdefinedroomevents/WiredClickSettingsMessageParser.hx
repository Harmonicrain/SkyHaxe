package com.sulake.habbo.communication.messages.parser.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    /** July Wired click-settings update: [userOption:int, furniOption:int]. */
     class WiredClickSettingsMessageParser implements IMessageParser
    {
        var _userOption:Int = 0;
        var _furniOption:Int = 0;

        public function flush():Bool
        {
            this._userOption = 0;
            this._furniOption = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k.bytesAvailable != 8)
            {
                return false;
            }
            this._userOption = k.readInteger();
            this._furniOption = k.readInteger();
            return true;
        }

        public var userOption(get,never):Int;
function  get_userOption():Int
        {
            return this._userOption;
        }

        public var furniOption(get,never):Int;
function  get_furniOption():Int
        {
            return this._furniOption;
        }

	public function new() {}
    }

