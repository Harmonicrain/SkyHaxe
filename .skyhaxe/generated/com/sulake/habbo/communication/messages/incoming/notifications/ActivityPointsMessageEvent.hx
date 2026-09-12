package com.sulake.habbo.communication.messages.incoming.notifications
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.notifications.ActivityPointsMessageParser;

     class ActivityPointsMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ActivityPointsMessageParser);
        }

        public var points(get,never):ASDictionary<ASAny,ASAny>;
public function  get_points():ASDictionary<ASAny,ASAny>
        {
            return Std.downcast(_parser , ActivityPointsMessageParser).points;
        }
    }

