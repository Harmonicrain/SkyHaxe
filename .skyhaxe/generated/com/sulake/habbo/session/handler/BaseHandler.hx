package com.sulake.habbo.session.handler
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.habbo.session.IRoomHandlerListener;

     class BaseHandler implements IDisposable 
    {
        var _connection:IConnection;
        var _listener:IRoomHandlerListener;
        var _disposed:Bool = false;
        public var _xxxRoomId:Int = 0;

        public function new(connection:IConnection, listener:IRoomHandlerListener)
        {
            this._connection = connection;
            this._listener = listener;
        }

        public function dispose()
        {
            this._connection = null;
            this._listener = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var connection(get,never):IConnection;
public function  get_connection():IConnection
        {
            return this._connection;
        }

        public var listener(get,never):IRoomHandlerListener;
public function  get_listener():IRoomHandlerListener
        {
            return this._listener;
        }
    }

