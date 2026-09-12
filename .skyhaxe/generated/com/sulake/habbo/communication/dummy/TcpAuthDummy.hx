package com.sulake.habbo.communication.dummy
;
    import flash.net.Socket;
    import flash.utils.Timer;
    import flash.events.Event;
    import flash.events.SecurityErrorEvent;
    import flash.events.IOErrorEvent;
    import flash.events.TimerEvent;

     class TcpAuthDummy 
    {
        var _socket:Socket;
        var _timeOutTimer:Timer;
        var _connectionMadeAndClosed:Bool = false;

        public function new(k:String, _arg_2:UInt)
        {
            this._socket = new Socket();
            this._socket.addEventListener(Event.CONNECT, (this.onConnect : ASAny));
            this._socket.addEventListener(Event.COMPLETE, (this.onComplete : ASAny));
            this._socket.addEventListener(Event.CLOSE, (this.onClose : ASAny));
            this._socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, (this.onSecurityError : ASAny));
            this._socket.addEventListener(IOErrorEvent.IO_ERROR, (this.onIOError : ASAny));
            this._socket.connect(k, ASCompat.toInt(_arg_2));
            this._timeOutTimer = new Timer(3500, 1);
            this._timeOutTimer.addEventListener(TimerEvent.TIMER, (this.onTimeOutTimer : ASAny));
            this._timeOutTimer.start();
        }

        function onTimeOutTimer(k:TimerEvent)
        {
            this.dispose();
            this._connectionMadeAndClosed = true;
        }

        function onConnect(k:Event)
        {
            Logger.log(["TcpAuth control socket connected"]);
            this.gracefulClose();
        }

        function onClose(k:Event)
        {
            Logger.log(["TcpAuth control socket closed"]);
            this.gracefulClose();
        }

        function onComplete(k:Event)
        {
            Logger.log(["TcpAuth control socket complete"]);
            this.gracefulClose();
        }

        function onSecurityError(k:SecurityErrorEvent)
        {
            Logger.log(["TcpAuth control socket security error"]);
            this.gracefulClose();
        }

        function onIOError(k:IOErrorEvent)
        {
            Logger.log(["TcpAuth control socket io error"]);
            this.gracefulClose();
        }

        public var connected(get,never):Bool;
public function  get_connected():Bool
        {
            return (!(this._socket == null)) && this._socket.connected;
        }

        public function gracefulClose()
        {
            if (this.connected)
            {
                this.dispose();
            }
            this._connectionMadeAndClosed = true;
        }

        public function dispose()
        {
            if (this._socket != null)
            {
                if (this._socket.connected)
                {
                    this._socket.close();
                }
                this._socket = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return !this.connected;
        }

        public var _Str_24860(get,never):Bool;
public function  get__Str_24860():Bool
        {
            return this._connectionMadeAndClosed;
        }
    }

