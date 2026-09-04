package com.sulake.habbo.communication.messages.incoming.game.lobby
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.game.lobby.AchievementResolutionsMessageParser;

     class AchievementResolutionsMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, AchievementResolutionsMessageParser);
        }

        public function getParser():AchievementResolutionsMessageParser
        {
            return Std.downcast(this._parser , AchievementResolutionsMessageParser);
        }
    }

