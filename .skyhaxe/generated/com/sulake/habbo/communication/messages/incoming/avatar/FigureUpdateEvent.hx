package com.sulake.habbo.communication.messages.incoming.avatar
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.avatar.FigureUpdateParser;

     class FigureUpdateEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, FigureUpdateParser);
        }

        function getParser():FigureUpdateParser
        {
            return Std.downcast(this._parser , FigureUpdateParser);
        }

        public var figure(get,never):String;
public function  get_figure():String
        {
            return Std.downcast(_parser , FigureUpdateParser).figure;
        }

        public var gender(get,never):String;
public function  get_gender():String
        {
            return Std.downcast(_parser , FigureUpdateParser).gender;
        }
    }

