package com.sulake.habbo.session
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.utils.Map;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.habbo.communication.messages.outgoing.users.GetUserTagsMessageComposer;

     class _Str_8883 implements IDisposable 
    {
        var _Str_17483:Map;
        var _sessionDataManager:SessionDataManager;

        public function new(k:SessionDataManager)
        {
            this._sessionDataManager = k;
            this._Str_17483 = new Map();
        }

        public function _Str_24368(k:Int):Array<ASAny>
        {
            var connection:IConnection = null;
            var _local_2:Array<ASAny> = ASCompat.dynamicAs(this._Str_17483.getValue(k) , Array);
            if (_local_2 != null)
            {
                return _local_2.slice(0);
            }
            if (this._sessionDataManager.communication != null)
            {
                connection = this._sessionDataManager.communication.connection;
                if (connection != null)
                {
                    connection.send(new GetUserTagsMessageComposer(k));
                }
            }
            return null;
        }

        public function dispose()
        {
            if (this.disposed)
            {
                return;
            }
            this._sessionDataManager = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._sessionDataManager == null;
        }

        public function _Str_25163(k:Int, _arg_2:Array<ASAny>)
        {
            this._Str_17483.add(k, _arg_2);
        }
    }

