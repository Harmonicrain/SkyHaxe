package com.sulake.habbo.communication.messages.parser.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredMessageDataValidator;

     class WiredEnvironmentMessageParser implements IMessageParser
    {
        static inline final MAX_ACHIEVEMENTS= 4096;

        var _hasClickUserWired:Bool = false;
        var _enabledAchievements:Vector<String>;

        public function flush():Bool
        {
            this._hasClickUserWired = false;
            this._enabledAchievements = new Vector<String>();
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
var count = 0, i = 0;            try
            {
                WiredMessageDataValidator.requireBytes(k, 1, "Wired environment");
                this._hasClickUserWired = k.readBoolean();
                this._enabledAchievements = new Vector<String>();
                if (k.bytesAvailable > 0)
                {
count= WiredMessageDataValidator.readCount(k, 2,
                        MAX_ACHIEVEMENTS, "Wired environment achievements");
                    for (_tmp_ in 0...count)
                    {
i= _tmp_;
                        this._enabledAchievements.push(k.readString());
                    }
                }
                return k.bytesAvailable == 0;
            }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);             {
                this.flush();
                return false;
            }
 }            return false;
        }

        public var hasClickUserWired(get,never):Bool;
public function  get_hasClickUserWired():Bool
        {
            return this._hasClickUserWired;
        }

        public var enabledAchievements(get,never):Vector<String>;
public function  get_enabledAchievements():Vector<String>
        {
            return this._enabledAchievements;
        }

	public function new() {}
    }

