package com.sulake.habbo.events.js
;
    import com.sulake.habbo.game.HabboGameManager;
    import flash.external.ExternalInterface;

     class JsMessageHandler 
    {
        static inline final _Str_16027= ";";
        static final _Str_13589:String = ASCompat.stringFromCharCode(31);

        var _manager:HabboGameManager;
        var _isDisposed:Bool = false;
        var _marshallExceptions:Bool = false;

        public function new(k:HabboGameManager, _arg_2:Bool=false)
        {
            this._manager = k;
            this._marshallExceptions = _arg_2;
            if (ExternalInterface.available)
            {
                ExternalInterface.addCallback(JsEventToHabboEnum.HABBOGAMEJSAPIEVENTTOHABBO, this._Str_23909);
            }
        }

        public function dispose()
        {
            this._manager = null;
            this._isDisposed = true;
        }

        function _Str_23909(k:String=null)
        {
            var _local_6:String = null;
            var _local_7:String = null;
            var _local_8:String = null;
            var _local_9:String = null;
            var _local_10:Array<ASAny> = null;
            if (this._isDisposed)
            {
                return;
            }
            var _local_2= ExternalInterface.marshallExceptions;
            ExternalInterface.marshallExceptions = this._marshallExceptions;
            var _local_3= k.indexOf(_Str_16027);
            var _local_4= k.indexOf(_Str_13589);
            var _local_5= k.substr(0, (_local_3 + 1));
            if (_local_4 != -1)
            {
                _local_6 = k.substr((_local_3 + 1), ((_local_4 - _local_3) - 1));
            }
            else
            {
                _local_6 = k.substr((_local_3 + 1));
            }
            switch (_local_6)
            {
                case JsEventToHabboEnum.QUIT_GAME_EVENT:
                    this._manager._Str_20515();
                    
                case JsEventToHabboEnum.HABBOGAMEAPI_GAME_LOADED:
                    this._manager._Str_22015();
                    
                case JsEventToHabboEnum.HABBOGAMEAPI_GAME_CRASHED:
                    _local_9 = null;
                    _local_10 = (cast k.split(_Str_13589));
                    if (_local_10.length >= 3)
                    {
                        _local_7 = _local_10[1];
                        _local_8 = _local_10[2];
                        if (_local_10.length >= 4)
                        {
                            _local_9 = _local_10[3];
                        }
                        this._manager._Str_21246(_local_7, _local_8, _local_9);
                    }
                    else
                    {
                        Logger.log([("Invalid game API event: " + k)]);
                    }
                    
            }
            ExternalInterface.marshallExceptions = _local_2;
        }

        public function sendGameEvent(event:String)
        {
            var preValue = false;
            try
            {
                if (ExternalInterface.available)
                {
                    preValue = ExternalInterface.marshallExceptions;
                    ExternalInterface.marshallExceptions = this._marshallExceptions;
                    ExternalInterface.call(JsEventToGameEnum.FLASHEXTERNALGAMEINTERFACE_SENDGAMEEVENT, [event]);
                    ExternalInterface.marshallExceptions = preValue;
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Logger.log([("Failed to send event to game: " + e)]);
            }
 }        }
    }

