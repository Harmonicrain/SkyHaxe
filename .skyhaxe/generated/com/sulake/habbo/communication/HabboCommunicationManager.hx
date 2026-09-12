package com.sulake.habbo.communication
;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.communication.connection.IConnectionStateListener;
    import com.sulake.core.communication.ICoreCommunicationManager;
    import com.sulake.core.communication.messages.IMessageConfiguration;
    import flash.utils.Timer;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.habbo.communication.dummy.TcpAuthDummy;
    import flash.events.Event;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDCoreCommunicationManager;
    import com.sulake.iid.IIDHabboConfigurationManager;
    import com.sulake.habbo.communication._enum.HabboCommunicationEvent;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import com.sulake.core.Core;
    import com.sulake.habbo.communication._enum.HabboConnectionType;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.utils.ErrorReportStorage;
    import com.sulake.habbo.tracking.HabboErrorVariableEnum;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.communication.encryption.ArcFour;
    import com.sulake.core.communication.encryption.IEncryption;
    import com.sulake.habbo.communication.encryption.DiffieHellman;
    import com.hurlant.math.BigInteger;
    import com.sulake.core.communication.handshake.IKeyExchange;
    import flash.events.TimerEvent;
    import com.sulake.habbo.communication.messages.outgoing.handshake.DisconnectMessageComposer;
    import com.sulake.iid.*;

     class HabboCommunicationManager extends Component implements IHabboCommunicationManager implements  IConnectionStateListener 
    {
        static inline final _Str_18533= 2;

        var _communication:ICoreCommunicationManager;
        var _messages:IMessageConfiguration;
        var _host:String = "";
        var _ports:Array<ASAny>;
        var _portIndex:Int = -1;
        var _nextPortTimer:Timer;
        var _connectionAttempts:Int = 1;
        var _handledMessageIds:String = "";
        var _connectionFailed:Bool = false;
        var _connectionRequested:Bool = false;
        var _a4:Array<ASAny>;
        var _configurationsComplete:Bool = false;
        var _connection:IConnection;
        var _mode:Int = 0;
        var _dummyTimer:Timer;
        var _currentTcpDummy:TcpAuthDummy;
        var _requiresInitialRetryAttempt:Bool = true;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            this._messages = new HabboMessages();
            this._ports = [];
            this._nextPortTimer = new Timer(100, 1);
            this._a4 = [65191, 65178, 65178, 65177, 65185];
            super(k, _arg_2, _arg_3);
            k.events.addEventListener(Event.UNLOAD, this.unloading);
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDCoreCommunicationManager(), function (k:ICoreCommunicationManager)
            {
                _communication = k;
            }), new ComponentDependency(new IIDHabboConfigurationManager(), null, false, [{
                "type":Event.COMPLETE,
                "callback":this.onConfigurationComplete
            }])]));
        }

        function _Str_18093(k:Event)
        {
            this._connection.isAuthenticated();
        }

        function onConfigurationComplete(k:Event)
        {
            this._connection.isConfigured();
        }

        public var connection(get,never):IConnection;
public function  get_connection():IConnection
        {
            return this._connection;
        }

        
        public var mode(get,set):Int;
public function  get_mode():Int
        {
            return 0;
        }
public function  set_mode(k:Int):Int        {
            return this._mode = k;
        }

        public var port(get,never):Int;
public function  get_port():Int
        {
            if ((((this._ports.length == 0) || (this._portIndex < 0)) || (this._portIndex >= this._ports.length)))
            {
                return 0;
            }
            return ASCompat.toInt(this._ports[this._portIndex]);
        }

        override function initComponent()
        {
            context.events.addEventListener(HabboCommunicationEvent.HABBO_CONNECTION_EVENT_AUTHENTICATED, this._Str_18093);
            this._connection = this._communication.createConnection(this);
            this._connection.registerMessageClasses(this._messages);
            this._connection.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
            this._connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
            this._connection.addEventListener(Event.CONNECT, this.onConnect);
            this.updateHostParameters();
            if (this._connectionRequested)
            {
                this.tryNextPort();
            }
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            if (this._connection != null)
            {
                this._connection.dispose();
                this._connection = null;
            }
            super.dispose();
        }

        public function updateHostParameters()
        {
            var _local_5:String = null;
            var _local_8:String = null;
            var _local_9:Array<ASAny> = null;
            var _local_10 = 0;
            var k:Array<ASAny> = [65162, 65162, 65158, 65155];
            var _local_2:Array<ASAny> = [65234, 65174, 65168, 65175, 65165, 65229];
            var _local_3:Array<ASAny> = [65170, 65162, 65157, 65155];
            var _local_4:Array<ASAny> = [65186, 65168, 65178, 65171, 65171];
            var _local_6= getProperty(this.getKeyValue([this._a4, _local_4, _local_2, _local_3], 0), null);
            if (_local_6 == null)
            {
                Core.crash(this.getKeyValue([this._a4, _local_4, _local_2, _local_3], 0), Core.ERROR_CATEGORY_CONNECT_TO_PROXY);
                return;
            }
            if (false == false)
            {
                _local_9 = [];
                _local_10 = 1;
                while (_local_10 < 5)
                {
                    _local_6 = _local_6.substring(0, (_local_6.length - _local_10));
                    switch (_local_10)
                    {
                        case (_ == (488311 % 668) => true):
                            _local_9.push(_local_2);
                            
                        case (_ == (76 % 37) => true):
                            _local_9.push(_local_4);
                            
                        case (_ == (415524125 % 49157) => true):
                            _local_9.push(k);
                            
                        case (_ == (16 % 5) => true):
                            _local_9.push(this._a4);
                            

default:
                    }
                    _local_10++;
                }
                _local_5 = getProperty(this.getKeyValue(_local_9, 0), null);
            }
            if (_local_5 == null)
            {
                Core.crash(this.getKeyValue([this._a4, _local_4, _local_2, k], 0), Core.ERROR_CATEGORY_CONNECT_TO_PROXY);
                return;
            }
            this._ports = [];
            var _local_7:Array<ASAny> = (cast _local_5.split(","));
            if (checkNullIteratee(_local_7)) for (_tmp_ in _local_7)
            {
_local_8  = _tmp_;
                this._ports.push(ASCompat.parseInt(ASCompat.stringReplace(_local_8, " ", "")));
            }
            this._host = _local_6;
        }

        public function renewSocket()
        {
            if (this._dummyTimer != null)
            {
                this._dummyTimer.reset();
            }
            this._dummyTimer = null;
            this._connectionAttempts = 1;
            this._currentTcpDummy = null;
            this._requiresInitialRetryAttempt = true;
            if (this._connection != null)
            {
                this._connection.createSocket();
            }
        }

        public function initConnection(k:String)
        {
            switch (k)
            {
                case HabboConnectionType.HABBO_MAIN:
                    if (this._connection == null)
                    {
                        Core.crash("Tried to connect to proxy but connection was null", Core.ERROR_CATEGORY_CONNECT_TO_PROXY);
                        return;
                    }
                    this._connectionRequested = true;
                    if (allRequiredDependenciesInjected)
                    {
                        this.tryNextPort();
                    }
                    return;
            }
        }

        public function addHabboConnectionMessageEvent(k:IMessageEvent):IMessageEvent
        {
            if (this._connection != null)
            {
                this._connection.addMessageEvent(k);
            }
            return k;
        }

        public function removeHabboConnectionMessageEvent(k:IMessageEvent)
        {
            if (this._connection != null)
            {
                this._connection.removeMessageEvent(k);
            }
        }

        public function habboWebLogin(k:String, _arg_2:String):IHabboWebLogin
        {
            var _local_3= "";
            _local_3 = getProperty("url.prefix");
            _local_3 = ASCompat.stringReplace(_local_3, "http://", "");
            _local_3 = ASCompat.stringReplace(_local_3, "https://", "");
            return new HabboWebLogin(k, _arg_2, _local_3);
        }

        public function connectionInit(host:String, port:Int)
        {
            ErrorReportStorage.setParameter(HabboErrorVariableEnum.HOST, host);
            ErrorReportStorage.setParameter(HabboErrorVariableEnum.PORT, Std.string(port));
        }

        public function messageReceived(k:String)
        {
            ErrorReportStorage.setParameter(HabboErrorVariableEnum.RECE_MSG_TIME, Std.string(Date.now().getTime()));
            if (this._handledMessageIds.length > 0)
            {
                this._handledMessageIds = (this._handledMessageIds + (",R:" + k));
            }
            else
            {
                this._handledMessageIds = ("R:" + k);
            }
            if (this._handledMessageIds.length > 150)
            {
                this._handledMessageIds = this._handledMessageIds.substring((this._handledMessageIds.length - 150));
            }
        }

        public function messageSent(k:String)
        {
            ErrorReportStorage.setParameter(HabboErrorVariableEnum.SENT_MSG_TIME, Std.string(Date.now().getTime()));
            if (this._handledMessageIds.length > 0)
            {
                this._handledMessageIds = (this._handledMessageIds + (",S:" + k));
            }
            else
            {
                this._handledMessageIds = ("S:" + k);
            }
            if (this._handledMessageIds.length > 150)
            {
                this._handledMessageIds = this._handledMessageIds.substring((this._handledMessageIds.length - 150));
            }
        }

        public function messageParseError(k:IMessageDataWrapper)
        {
            ErrorReportStorage.setParameter(HabboErrorVariableEnum.SENT_MSG_DATA, Std.string(((k : ASObject) )));
            ErrorReportStorage.addDebugData("MESSAGE_QUEUE", this._handledMessageIds);
        }

        public function setMessageQueueErrorDebugData()
        {
            ErrorReportStorage.addDebugData("MESSAGE_QUEUE", this._handledMessageIds);
        }

        public function initializeEncryption():IEncryption
        {
            return new ArcFour();
        }

        public function initializeKeyExchange(prime:BigInteger, generator:BigInteger):IKeyExchange
        {
            return new DiffieHellman(prime, generator);
        }

        function getKeyValue(k:Array<ASAny>, _arg_2:Int):String
        {
            var _local_4:Array<ASAny> = null;
            var _local_5 = 0;
            var _local_3= "";
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_4  = _tmp_;
                if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
                {
_local_5  = ASCompat.toInt(_tmp_);
                    _local_3 = (_local_3 + ASCompat.stringFromCharCode(((65290 - _local_5) + _arg_2--)));
                }
            }
            return _local_3;
        }

        function tryNextPort()
        {
            this._host = getProperty("connection.info.host");
            var k = 0;
            if (this._connection == null)
            {
                return;
            }
            if (this._connection.connected)
            {
                return;
            }
            if (((!(this._currentTcpDummy == null)) && (!this._currentTcpDummy._Str_24860)))
            {
                if (this._dummyTimer == null)
                {
                    this._dummyTimer = new Timer(500);
                    this._dummyTimer.addEventListener(TimerEvent.TIMER, (this.onTryNextPort : ASAny));
                    this._dummyTimer.start();
                }
                else
                {
                    this._dummyTimer.reset();
                    this._dummyTimer.start();
                }
                return;
            }
            this._portIndex++;
            if (this._currentTcpDummy == null)
            {
                this._currentTcpDummy = new TcpAuthDummy((this._host + this.getKeyValue([([65290, 65290, 65290, 65290, 65290] : Array<Dynamic>), ([65290, 65290, 65290] : Array<Dynamic>), ([65290, 65290] : Array<Dynamic>)], 0)), ASCompat.toUInt(this._ports[this._portIndex]));
                this._portIndex--;
                this.resetPocketHabboSession();
                return;
            }
            if (this._portIndex >= this._ports.length)
            {
                ErrorReportStorage.addDebugData("ConnectionRetry", ("Connection attempt " + Std.string(this._connectionAttempts)));
                this._connectionAttempts++;
                k = _Str_18533;
                if (this._ports.length == 1)
                {
                    k++;
                }
                if (this._connectionAttempts <= k)
                {
                    this._portIndex = 0;
                }
                else
                {
                    if (this._connectionFailed)
                    {
                        return;
                    }
                    this._connectionFailed = true;
                    Core.error("Connection failed to host and ports", true, Core.ERROR_CATEGORY_CONNECT_TO_PROXY);
                    return;
                }
            }
            this._connection.timeout = (this._connectionAttempts * 10000);
            if (false == false)
            {
                this._connection.init((this._host + this.getKeyValue([([65290, 65290, 65290, 65290, 65290] : Array<Dynamic>), ([65290, 65290, 65290] : Array<Dynamic>), ([65290, 65290] : Array<Dynamic>)], 0)), ASCompat.toUInt(this._ports[this._portIndex]));
            }
            if (this._dummyTimer != null)
            {
                if (this._dummyTimer.running)
                {
                    this._dummyTimer.stop();
                }
                this._dummyTimer.removeEventListener(TimerEvent.TIMER, (this.onTryNextPort : ASAny));
            }
            this._dummyTimer = null;
            this._currentTcpDummy = null;
            if (this._requiresInitialRetryAttempt)
            {
                this._portIndex--;
                this._requiresInitialRetryAttempt = false;
            }
        }

        function resetPocketHabboSession()
        {
            this._nextPortTimer.addEventListener(TimerEvent.TIMER, (this.onTryNextPort : ASAny));
            this._nextPortTimer.start();
        }

        function unloading(k:Event)
        {
            if (this._connection != null)
            {
                this._connection.send(new DisconnectMessageComposer());
            }
        }

        function onIOError(k:IOErrorEvent)
        {
k.type;            ErrorReportStorage.addDebugData("Communication IO Error", ((((("IOError " + k.type) + " on connect: ") + k.text) + ". Port was ") + this._ports[this._portIndex]));
            this.resetPocketHabboSession();
        }

        function onConnect(k:Event)
        {
            ErrorReportStorage.addDebugData("Connection", (("Connected with " + Std.string(this._connectionAttempts)) + " attempts"));
        }

        function onTryNextPort(k:TimerEvent)
        {
            this.tryNextPort();
        }

        function onSecurityError(k:SecurityErrorEvent)
        {
            ErrorReportStorage.addDebugData("Communication Security Error", ((("SecurityError on connect: " + k.text) + ". Port was ") + this._ports[this._portIndex]));
            this.resetPocketHabboSession();
        }
    }

