package com.sulake.core.communication.messages
;
    import com.sulake.core.communication.connection.IConnection;

     class MessageEvent implements IMessageEvent 
    {
        var _callback:ASFunction;
        var _connection:IConnection;
        var _parserClass:Class<Dynamic>;
        var _parser:IMessageParser;

        public function new(callback:ASFunction, parserClass:Class<Dynamic>)
        {
            this._callback = callback;
            this._parserClass = parserClass;
        }

        public function dispose()
        {
            this._callback = null;
            this._parserClass = null;
            this._connection = null;
            this._parser = null;
        }

        public var callback(get,never):ASFunction;
function  get_callback():ASFunction
        {
            return this._callback;
        }

        
        public var connection(get,set):IConnection;
function  set_connection(connection:IConnection):IConnection        {
            return this._connection = connection;
        }
function  get_connection():IConnection
        {
            return this._connection;
        }

        public var parserClass(get,never):Class<Dynamic>;
function  get_parserClass():Class<Dynamic>
        {
            return this._parserClass;
        }

        
        public var parser(get,set):IMessageParser;
function  get_parser():IMessageParser
        {
            return this._parser;
        }
function  set_parser(parser:IMessageParser):IMessageParser        {
            return this._parser = parser;
        }
    }

