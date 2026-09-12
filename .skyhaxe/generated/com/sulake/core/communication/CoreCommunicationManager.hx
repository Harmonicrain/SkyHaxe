package com.sulake.core.communication
;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.core.communication.connection.SocketConnection;
    import com.sulake.core.communication.connection.IConnectionStateListener;

     class CoreCommunicationManager extends Component implements ICoreCommunicationManager implements  IUpdateReceiver 
    {
        var _connections:Array<ASAny>;

        public function new(k:IContext, _arg_2:UInt=0)
        {
            super(k, _arg_2);
            this._connections = new Array<ASAny>();
            registerUpdateReceiver(this, 0);
        }

        override public function dispose()
        {
            var k:IConnection = null;
            removeUpdateReceiver(this);
            final _iter_ = this._connections; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k.dispose();
            }
            this._connections = null;
            super.dispose();
        }

        public function createConnection(k:IConnectionStateListener=null):IConnection
        {
            var _local_2:IConnection = new SocketConnection(this, k);
            this._connections.push(_local_2);
            return _local_2;
        }

        public function update(k:UInt)
        {
            var _local_3:IConnection = null;
            var _local_2 = 0;
            while (_local_2 < this._connections.length)
            {
                _local_3 = this._connections[_local_2];
                _local_3.processReceivedData();
                if (disposed)
                {
                    return;
                }
                if (_local_3.disposed)
                {
                    this._connections.splice(_local_2, 1);
                }
                else
                {
                    _local_2++;
                }
            }
        }
    }

