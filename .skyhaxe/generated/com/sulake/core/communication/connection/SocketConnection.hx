package com.sulake.core.communication.connection
;
    import com.sulake.core.runtime.events.EventDispatcherWrapper;
    import com.sulake.core.runtime.IDisposable;
    import flash.net.Socket;
    import flash.utils.Timer;
    import flash.utils.ByteArray;
    import com.sulake.core.communication.wireformat.IWireFormat;
    import com.sulake.core.communication.encryption.IEncryption;
    import com.sulake.core.communication.messages.MessageClassManager;
    import com.sulake.core.communication.ICoreCommunicationManager;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.wireformat.EvaWireFormat;
    import flash.events.TimerEvent;
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.IOErrorEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import Globals.flash_utils_getQualifiedClassName as getQualifiedClassName;
    import com.sulake.core.utils.ClassUtils;
    import com.sulake.core.communication.messages.IPreEncryptionMessage;
    import com.sulake.core.communication.messages.IMessageConfiguration;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.Core;
    import com.sulake.core.utils.ErrorReportStorage;
    import flash.events.*;

     class SocketConnection extends EventDispatcherWrapper implements IConnection implements  IDisposable 
    {
        public static inline final DEFAULT_SOCKET_TIMEOUT= 10000;

        var _socket:Socket;
        var _timeOutTimer:Timer;
        var _timeOutStarted:Int = 0;
        var _dataBuffer:com.sulake.core.utils.ByteArray;
        var _wireFormat:IWireFormat;
        var _clientToServerEncryption:IEncryption;
        var _serverToClientEncryption:IEncryption;
        var _messageClassManager:MessageClassManager;
        var _communicationManager:ICoreCommunicationManager;
        var _stateListener:IConnectionStateListener;
        var _authenticated:Bool = false;
        var _configurationReady:Bool = false;
        var _pendingClientMessages:Vector<IMessageComposer>;
        var _pendingServerMessages:Vector<IMessageDataWrapper>;
        var _lastProcessedMessage:IMessageDataWrapper;

        public function new(communicationManager:ICoreCommunicationManager, stateListener:IConnectionStateListener)
        {
            super();
            this._communicationManager = communicationManager;
            this._messageClassManager = new MessageClassManager();
            this._wireFormat = new EvaWireFormat();
            this.createSocket();
            this._timeOutTimer = new Timer(DEFAULT_SOCKET_TIMEOUT, 1);
            this._timeOutTimer.addEventListener(TimerEvent.TIMER, (this.onTimeOutTimer : ASAny));
            this._stateListener = stateListener;
        }

        override public function dispose()
        {
            if (!disposed)
            {
                this._Str_20244();
                if (this._timeOutTimer != null)
                {
                    this._timeOutTimer.stop();
                    this._timeOutTimer.removeEventListener(TimerEvent.TIMER, (this.onTimeOutTimer : ASAny));
                }
                this._timeOutTimer = null;
                this._dataBuffer = null;
                this._stateListener = null;
                this._clientToServerEncryption = null;
                this._serverToClientEncryption = null;
                this._wireFormat = null;
                if (this._messageClassManager != null)
                {
                    this._messageClassManager.dispose();
                }
                this._messageClassManager = null;
                this._communicationManager = null;
                this._stateListener = null;
                this._lastProcessedMessage = null;
                super.dispose();
            }
        }

        public function createSocket()
        {
            this._Str_20244();
            this._dataBuffer = new com.sulake.core.utils.ByteArray();
            this._serverToClientEncryption = null;
            this._clientToServerEncryption = null;
            this._socket = new Socket();
            this._socket.addEventListener(Event.CONNECT, (this.onConnect : ASAny));
            this._socket.addEventListener(Event.COMPLETE, (this.onComplete : ASAny));
            this._socket.addEventListener(Event.CLOSE, (this.onClose : ASAny));
            this._socket.addEventListener(ProgressEvent.SOCKET_DATA, (this.onRead : ASAny));
            this._socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, (this.onSecurityError : ASAny));
            this._socket.addEventListener(IOErrorEvent.IO_ERROR, (this.onIOError : ASAny));
        }

        function _Str_20244()
        {
            if (this._socket != null)
            {
                this._socket.removeEventListener(Event.CONNECT, (this.onConnect : ASAny));
                this._socket.removeEventListener(Event.COMPLETE, (this.onComplete : ASAny));
                this._socket.removeEventListener(Event.CLOSE, (this.onClose : ASAny));
                this._socket.removeEventListener(ProgressEvent.SOCKET_DATA, (this.onRead : ASAny));
                this._socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, (this.onSecurityError : ASAny));
                this._socket.removeEventListener(IOErrorEvent.IO_ERROR, (this.onIOError : ASAny));
                if (this._socket.connected)
                {
                    this._socket.close();
                }
                this._socket = null;
            }
        }

        public function init(k:String, _arg_2:UInt=0):Bool
        {
            #if (js && html5)
            var nullIndex = k.indexOf(String.fromCharCode(0));
            if (nullIndex >= 0)
            {
                k = k.substring(0, nullIndex);
            }
            #end
            if (this._stateListener != null)
            {
                this._stateListener.connectionInit(k, ASCompat.toInt(_arg_2));
            }
            this._timeOutTimer.start();
            this._timeOutStarted = flash.Lib.getTimer();
            this._socket.connect(k, ASCompat.toInt(_arg_2));
            return true;
        }

        public var timeout(never,set):Int;
public function  set_timeout(k:Int):Int        {
            if (disposed)
            {
                return k;
            }
            this._timeOutTimer.delay = k;
return k;
        }

        public function addMessageEvent(k:IMessageEvent)
        {
            if (disposed)
            {
                return;
            }
            this._messageClassManager.registerMessageEvent(k);
        }

        public function removeMessageEvent(k:IMessageEvent)
        {
            if (disposed)
            {
                return;
            }
            this._messageClassManager.unregisterMessageEvent(k);
        }

        public function isAuthenticated()
        {
            this._authenticated = true;
        }

        public function isConfigured()
        {
var pendingServerMessage:IMessageDataWrapper  = null, data:Array<ASAny>  = null, pendingClientMessage:IMessageComposer  = null;            this._configurationReady = true;
            if (this._pendingServerMessages != null)
            {
                final _iter_ = this._pendingServerMessages; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
pendingServerMessage = _tmp_;
data= this.parseReceivedMessage(pendingServerMessage);
                    if (data != null)
                    {
                        this.handleReceivedMessage(pendingServerMessage.getID(), data);
                    }
                }
            }
            if (this._pendingClientMessages != null)
            {
                final _iter_ = this._pendingClientMessages; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
pendingClientMessage = _tmp_;
                    this.send(pendingClientMessage);
                }
                this._pendingClientMessages = null;
            }
            this._pendingClientMessages = new Vector<IMessageComposer>(0);
            this._pendingServerMessages = new Vector<IMessageDataWrapper>(0);
        }

        public function send(message:IMessageComposer):Bool
        {
var _local_5:com.sulake.core.utils.ByteArray  = null;            if (disposed)
            {
                return false;
            }
            if ((this._authenticated && (!this._configurationReady)))
            {
                if (this._pendingClientMessages == null)
                {
                    this._pendingClientMessages = new Vector<IMessageComposer>(0);
                }
                this._pendingClientMessages.push(message);
                return false;
            }
            var _local_2= this._messageClassManager.getMessageIDForComposer(message);
            if (_local_2 < 0)
            {
                return false;
            }
            var _local_3= message.getMessageArray();
            var _local_4= this._wireFormat.encode(_local_2, _local_3);
            if (this._stateListener != null)
            {
                this._stateListener.messageSent(Std.string(_local_2));
            }
            if (this._socket.connected)
            {
                if (this._clientToServerEncryption != null)
                {
_local_5= this._clientToServerEncryption.encipher(_local_4);
                    if (_local_5 != _local_4)
                    {
                        this._socket.writeBytes(_local_5);
                        this._socket.flush();
                    }
                }
                else
                {
                    this._socket.writeBytes(_local_4);
                    this._socket.flush();
                }
            }
            else
            {
                return false;
            }
            return true;
        }

        public function sendUnencrypted(k:IMessageComposer):Bool
        {
            if (disposed)
            {
                return false;
            }
            var _local_2= this._messageClassManager.getMessageIDForComposer(k);
            if (_local_2 < 0)
            {
                return false;
            }
            var _local_3= k.getMessageArray();
            var _local_4= this._wireFormat.encode(_local_2, _local_3);
            var _local_5= getQualifiedClassName(k);
            var _local_6= Type.resolveClass(_local_5) ;
            if (!ClassUtils.implementsInterface(_local_6, IPreEncryptionMessage))
            {
                return false;
            }
            if (this._stateListener != null)
            {
                this._stateListener.messageSent(Std.string(_local_2));
            }
            if (this._socket.connected)
            {
                this._socket.writeBytes(_local_4);
                this._socket.flush();
            }
            else
            {
                return false;
            }
            return true;
        }

        public function setEncryption(outgoing:IEncryption, incoming:IEncryption)
        {
            this._clientToServerEncryption = outgoing;
            this._serverToClientEncryption = incoming;
        }

        public function registerMessageClasses(k:IMessageConfiguration)
        {
            this._messageClassManager.registerMessages(k);
        }

        function processData()
        {
var lastId = 0, messages:Array<ASAny>  = null;            var toProcess:Array<ASAny> = null;
			toProcess = this.splitReceivedMessages();
            if (checkNullIteratee(toProcess)) for (_tmp_ in toProcess)
            {
this._lastProcessedMessage  = _tmp_;
lastId= this._lastProcessedMessage.getID();
                if (this._stateListener != null)
                {
                    this._stateListener.messageReceived(Std.string(lastId));
                }
                if ((this._authenticated && (!this._configurationReady)))
                {
                    if (this._pendingServerMessages == null)
                    {
                        this._pendingServerMessages = new Vector<IMessageDataWrapper>(0);
                    }
                    this._pendingServerMessages.push(this._lastProcessedMessage);
                }
                else
                {
messages= this.parseReceivedMessage(this._lastProcessedMessage);
                    if (messages == null)
                    {
                    }
                    else
                    {
                        this.handleReceivedMessage(lastId, messages);
                    }
                }
            }
        }

        public function processReceivedData()
        {
            if (disposed)
            {
                return;
            }
            try
            {
                this.processData();
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                if (((_stateListener != null) && (_lastProcessedMessage != null)))
                {
                    _stateListener.messageParseError(_lastProcessedMessage);
                }
                if (!disposed)
                {
                    throw e;
                }
            }
 }        }

        function splitReceivedMessages():Array<ASAny>
        {
var remainingBuffer:com.sulake.core.utils.ByteArray  = null;            this._dataBuffer.position = 0;
            if (this._dataBuffer.bytesAvailable == 0)
            {
                return new Array<ASAny>();
            }
            var buffer= this._wireFormat.decode(this._dataBuffer, this);
            if (this._dataBuffer.bytesAvailable == 0)
            {
                this._dataBuffer = new com.sulake.core.utils.ByteArray();
            }
            else
            {
                if (this._dataBuffer.position > 0)
                {
remainingBuffer= new com.sulake.core.utils.ByteArray();
ASCompat.byteArrayWriteBytes(                    remainingBuffer, this._dataBuffer, this._dataBuffer.position);
                    this._dataBuffer = remainingBuffer;
                }
            }
            return buffer;
        }

        function parseReceivedMessage(message:IMessageDataWrapper):Array<ASAny>
        {
            var parser:IMessageParser = null;
            var events= this._messageClassManager.getMessageEventsForID(message.getID());
            if (events != null)
            {
                parser = ASCompat.dynamicAs(events[0] , IMessageEvent).parser;
                try
                {
                    parser.flush();
                    parser.parse(message);
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                    Core.crash((getKeyValue([([65220, 65192, 65183, 65179] : Array<Dynamic>), ([65185, 65185, 65252, 65167] : Array<Dynamic>), ([65171, 65249, 65168, 65182] : Array<Dynamic>), ([65164, 65162, 65175, 65243] : Array<Dynamic>), ([65169, 65163, 65173, 65160] : Array<Dynamic>), ([65161, 65164, 65158, 65164] : Array<Dynamic>), ([65234, 65156, 65163, 65148] : Array<Dynamic>), ([65147, 65164, 65157, 65158] : Array<Dynamic>), ([65226, 65140, 65141, 65150, 65144, 65150] : Array<Dynamic>)], 0) + getQualifiedClassName(parser)), e.errorID, e);
                    //Core.crash(("Failed to parse incoming message using" + getQualifiedClassName(parser)), e.errorID, e);
                }
 }            }
            return events;
        }

        function handleReceivedMessage(k:Int, _arg_2:Array<ASAny>)
        {
            var _local_3:IMessageEvent = null;
            if (checkNullIteratee(_arg_2)) for (_tmp_ in _arg_2)
            {
_local_3  = _tmp_;
                _local_3.connection = this;
                _local_3.callback(_local_3);
            }
        }

        public var connected(get,never):Bool;
public function  get_connected():Bool
        {
            if (this._socket == null)
            {
                return false;
            }
            return this._socket.connected;
        }

        public function close()
        {
            if (this._socket == null)
            {
                return;
            }
            return this._socket.close();
        }

        function onRead(k:ProgressEvent)
        {
            if (this._socket == null)
            {
                return;
            }
            this._dataBuffer.position = this._dataBuffer.length;
            this._socket.readBytes(this._dataBuffer, this._dataBuffer.position);
        }

        public function getServerToClientEncryption():IEncryption
        {
            return this._serverToClientEncryption;
        }

        function onConnect(k:Event)
        {
            this._timeOutTimer.stop();
            ErrorReportStorage.addDebugData(this.getKeyValue([([65223, 65178, 65178, 65177] : Array<Dynamic>), ([65185, 65186, 65168, 65178] : Array<Dynamic>), ([65171, 65171, 65196, 65174] : Array<Dynamic>), ([65169, 65176, 65162] : Array<Dynamic>)], 0), (this.getKeyValue([([65223, 65178, 65178, 65177] : Array<Dynamic>), ([65185, 65186, 65168, 65182] : Array<Dynamic>), ([65182, 65249, 65175, 65169, 65246] : Array<Dynamic>)], 0) + Std.string(flash.Lib.getTimer() - this._timeOutStarted)));
            //ErrorReportStorage.addDebugData("ConnectionTimer", ("Connected in " + (getTimer() - this._timeOutStarted)));
            dispatchEvent(k);
        }

        function onClose(k:Event)
        {
            this._timeOutTimer.stop();
            #if html5
            skyhaxe.CmsBridge.disconnected(0, false);
            #end
            ErrorReportStorage.addDebugData(this.getKeyValue([([65223, 65178, 65178, 65177] : Array<Dynamic>), ([65185, 65186, 65168, 65178] : Array<Dynamic>), ([65171, 65171, 65196, 65174] : Array<Dynamic>), ([65169, 65176, 65162] : Array<Dynamic>)], 0), (this.getKeyValue([([65223, 65181, 65177, 65172] : Array<Dynamic>), ([65185, 65185, 65252, 65178] : Array<Dynamic>), ([65172, 65249] : Array<Dynamic>)], 0) + Std.string(flash.Lib.getTimer() - this._timeOutStarted)));
            //ErrorReportStorage.addDebugData("ConnectionTimer", ("Closed in " + (getTimer() - this._timeOutStarted)));
            dispatchEvent(k);
        }

        function onComplete(k:Event)
        {
            this._timeOutTimer.stop();
            ErrorReportStorage.addDebugData(this.getKeyValue([([65223, 65178, 65178, 65177] : Array<Dynamic>), ([65185, 65186, 65168, 65178] : Array<Dynamic>), ([65171, 65171, 65196, 65174] : Array<Dynamic>), ([65169, 65176, 65162] : Array<Dynamic>)], 0), (this.getKeyValue([([65223, 65178, 65179, 65175] : Array<Dynamic>), ([65178, 65184, 65168, 65182] : Array<Dynamic>), ([65182, 65249, 65175, 65169, 65246] : Array<Dynamic>)], 0) + Std.string(flash.Lib.getTimer() - this._timeOutStarted)));
            //ErrorReportStorage.addDebugData("ConnectionTimer", ("Completed in " + (getTimer() - this._timeOutStarted)));
            dispatchEvent(k);
        }

        function onSecurityError(k:SecurityErrorEvent)
        {
            this._timeOutTimer.stop();
            ErrorReportStorage.addDebugData(this.getKeyValue([([65223, 65178, 65178, 65177] : Array<Dynamic>), ([65185, 65186, 65168, 65178] : Array<Dynamic>), ([65171, 65171, 65196, 65174] : Array<Dynamic>), ([65169, 65176, 65162] : Array<Dynamic>)], 0), (this.getKeyValue([([65207, 65188, 65189, 65170] : Array<Dynamic>), ([65172, 65180, 65168, 65162] : Array<Dynamic>), ([65213, 65167, 65166, 65168] : Array<Dynamic>), ([65164, 65245, 65171, 65165, 65242] : Array<Dynamic>)], 0) + Std.string(flash.Lib.getTimer() - this._timeOutStarted)));
            //ErrorReportStorage.addDebugData("ConnectionTimer", ("SecurityError in " + (getTimer() - this._timeOutStarted)));
            dispatchEvent(k);
        }

        function onIOError(k:IOErrorEvent)
        {
            this._timeOutTimer.stop();
            ErrorReportStorage.addDebugData(this.getKeyValue([([65223, 65178, 65178, 65177] : Array<Dynamic>), ([65185, 65186, 65168, 65178] : Array<Dynamic>), ([65171, 65171, 65196, 65174] : Array<Dynamic>), ([65169, 65176, 65162] : Array<Dynamic>)], 0), (this.getKeyValue([([65217, 65210, 65219, 65173] : Array<Dynamic>), ([65172, 65174, 65170, 65251] : Array<Dynamic>), ([65177, 65171, 65248] : Array<Dynamic>)], 0) + Std.string(flash.Lib.getTimer() - this._timeOutStarted)));
k.type;            dispatchEvent(k);
        }

        function onTimeOutTimer(k:TimerEvent)
        {
            this._timeOutTimer.stop();
            ErrorReportStorage.addDebugData(this.getKeyValue([([65223, 65178, 65178, 65177] : Array<Dynamic>), ([65185, 65186, 65168, 65178] : Array<Dynamic>), ([65171, 65171, 65196, 65174] : Array<Dynamic>), ([65169, 65176, 65162] : Array<Dynamic>)], 0), (this.getKeyValue([([65206, 65184, 65179, 65186] : Array<Dynamic>), ([65207, 65168, 65168, 65251] : Array<Dynamic>), ([65177, 65171, 65248, 65247] : Array<Dynamic>)], 0) + Std.string(flash.Lib.getTimer() - this._timeOutStarted)));
            //ErrorReportStorage.addDebugData("ConnectionTimer", ("TimeOut in  " + (getTimer() - this._timeOutStarted)));
            var ioErrorEvent= new IOErrorEvent(IOErrorEvent.IO_ERROR);
            ioErrorEvent.text = ((this.getKeyValue([([65207, 65178, 65189, 65180] : Array<Dynamic>), ([65185, 65169, 65252, 65199] : Array<Dynamic>), ([65177, 65172, 65179, 65168] : Array<Dynamic>), ([65161, 65161, 65244, 65235] : Array<Dynamic>)], 0) + Std.string(this._timeOutTimer.delay)) + this.getKeyValue([([65258, 65180, 65173, 65246] : Array<Dynamic>), ([65240, 65253, 65204, 65172] : Array<Dynamic>), ([65167, 65166, 65175, 65181] : Array<Dynamic>), ([65170, 65176, 65244, 65205] : Array<Dynamic>), ([65169, 65159, 65171, 65152] : Array<Dynamic>), ([65173, 65161, 65160, 65221] : Array<Dynamic>)], 0));
            //ioErrorEvent.text = (("Socket Timeout (" + this._timeOutTimer.delay) + " ms). Possible Firewall.");
            dispatchEvent(ioErrorEvent);
        }

        function getKeyValue(keys:Array<ASAny>, value:Int):String
        {
var key:Array<ASAny>  = null, header = 0;            var result= "";
            if (checkNullIteratee(keys)) for (_tmp_ in keys)
            {
key = _tmp_;
                if (checkNullIteratee(key)) for (_tmp_ in key)
                {
header = ASCompat.toInt(_tmp_);
                    result = (result + ASCompat.stringFromCharCode(((65290 - header) + value--)));
                }
            }
            return result;
        }
    }

