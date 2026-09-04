package com.sulake.habbo.communication.messages.parser.tickets
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.tickets.TicketProtocol;

     final class TicketMessageParser implements IMessageParser
    {
        var _header:Int = 0;
        var _data:ASObject;

        public var header(get,never):Int;
function  get_header():Int { return this._header; }
        public var data(get,never):ASObject;
function  get_data():ASObject { return this._data; }

        public function flush():Bool
        {
            this._header = 0;
            this._data = {};
            return true;
        }

        public function parse(message:IMessageDataWrapper):Bool
        {
            if (message == null) return false;
            this._header = message.getID();
            this._data = {};
            try
            {
                switch (this._header)
                {
                    case TicketProtocol.BALANCE:
                        this._data.ticketBalance = message.readInteger();
                        if (this._data.ticketBalance < 0) throw new ASError("Invalid ticket balance");
                        
                    case TicketProtocol.PURCHASE_RESULT:
                        this._data.status = message.readInteger();
                        this._data.recipient = message.readString();
                        this._data.ticketsAdded = message.readInteger();
                        if (this._data.status < 0 || this._data.status > 4 || this._data.ticketsAdded < 0)
                            throw new ASError("Invalid ticket purchase result");
                        
                    default:
                        return false;
                }
                return message.bytesAvailable == 0;
            }
            catch (error:ASError)
            {
                this.flush();
                return false;
            }
            return false;
        }

	public function new() {}
    }

