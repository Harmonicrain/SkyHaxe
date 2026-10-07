package com.sulake.habbo.communication.messages.parser.help
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.parser.help.data.PendingGuideTicket;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GuideReportingStatusMessageParser implements IMessageParser
    {
        public static inline final GUIDE_REPORTING_STATUS_OK= 0;
        public static inline final GUIDE_REPORTING_STATUS_PENDING_TICKET= 1;
        public static inline final GUIDE_REPORTING_STATUS_ABUSIVE= 2;
        public static inline final GUIDE_REPORTING_STATUS_REPORTING_TOO_QUICKLY= 3;

        var _statusCode:Int = 0;
        var _pendingTicket:PendingGuideTicket;


        public function flush():Bool
        {
            this._pendingTicket = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._statusCode = k.readInteger();
            if (this._statusCode == GUIDE_REPORTING_STATUS_PENDING_TICKET)
            {
                this._pendingTicket = new PendingGuideTicket(k);
            }
            return true;
        }

        public var statusCode(get,never):Int;
public function  get_statusCode():Int
        {
            return this._statusCode;
        }

        public var pendingTicket(get,never):PendingGuideTicket;
public function  get_pendingTicket():PendingGuideTicket
        {
            return this._pendingTicket;
        }

        public var localizationCode(get,never):String;
public function  get_localizationCode():String
        {
            switch (this._statusCode)
            {
                case GUIDE_REPORTING_STATUS_ABUSIVE:
                    return "blocked";
                case GUIDE_REPORTING_STATUS_REPORTING_TOO_QUICKLY:
                    return "tooquick";
                default:
                    return "";
            }
        }

	public function new() {}
    }

