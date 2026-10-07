package com.sulake.habbo.game
;
    import com.sulake.habbo.game.HabboGameManager;
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.display.Stage;
    import com.sulake.core.utils.PlayerVersionCheck;

     class SharedMessageHandler 
    {
        var _habboGameManager:HabboGameManager;
        var _events:EventDispatcher;
        var _Str_16707:Int = -1;
        var _Str_580:Bool = false;

        public function new(k:HabboGameManager, _arg_2:EventDispatcher)
        {
            this._habboGameManager = k;
            this._events = _arg_2;
            this._events.addEventListener(SharedGameEvent.EVENT_TYPE_TO_HABBO, (this._Str_19772 : ASAny));
        }

        public function dispose()
        {
            this._events.removeEventListener(SharedGameEvent.EVENT_TYPE_TO_HABBO, (this._Str_19772 : ASAny));
            this._events = null;
            this._habboGameManager = null;
            this._Str_580 = true;
        }

        public var _Str_20452(get,never):Int;
public function  get__Str_20452():Int
        {
            return this._Str_16707;
        }

        public function send(k:Int, _arg_2:String, _arg_3:ASAny=null):Bool
        {
            this._events.dispatchEvent(new SharedGameEvent(SharedGameEvent.EVENT_TYPE_TO_GAME, k, _arg_2, _arg_3));
            return true;
        }

        public function _Str_19772(k:Event):Bool
        {
            var _local_4 = false;
            if (this._Str_580)
            {
                Logger.log([("Shared event received by disposed message handler: " + k)]);
                return false;
            }
            if (k.type != SharedGameEvent.EVENT_TYPE_TO_HABBO)
            {
                Logger.log(["Unknown event received as shared event!"]);
                return false;
            }
            var _local_2:ASObject = ((k : ASObject) );
            var _local_3= ASCompat.toInt(_local_2.api);
            switch (_local_3)
            {
                case 1:
                    _local_4 = this._Str_22451(_local_2);
                    
                default:
                    Logger.log(["Unknown api version for shared event!"]);
                    _local_4 = false;
            }
            if ((_local_4 && (this._Str_16707 == -1)))
            {
                this._Str_16707 = _local_3;
            }
            return _local_4;
        }

        function _Str_22451(k:ASObject):Bool
        {
            var _local_4:ASObject = null;
            var _local_2:String = k.name;
            var _local_3= 1;
            switch (_local_2)
            {
                case SharedEventToHabboEnum.STAGE3D_REQUEST:
                    _local_4 = this._Str_23983();
                    if (_local_4)
                    {
                        this.send(_local_3, SharedEventToGameEnum.STAGE3D_RESPONSE, _local_4);
                    }
                    else
                    {
                        this.send(_local_3, SharedEventToGameEnum.STAGE3D_RESPONSE_FAIL, null);
                    }
                    
                case SharedEventToHabboEnum.QUIT_GAME_EVENT:
                    this._habboGameManager._Str_20515();
                    
                default:
                    Logger.log([((("Unknown shared event name for api v" + Std.string(_local_3)) + ": ") + _local_2)]);
                    return false;
            }
            return true;
        }

        function _Str_23983():ASObject
        {
            var stage:Stage = null;
            var stage3D:ASObject = null;
            var i = 0;
            stage = this._habboGameManager.context.displayObjectContainer.stage;
            try
            {
                if (PlayerVersionCheck.majorVersion < 11)
                {
                    Logger.log(["Tried to get stage3D with too low player version"]);
                    return null;
                }
                if (stage.stage3Ds.length > 0)
                {
                    i = 0;
                    while (i < stage.stage3Ds.length)
                    {
                        stage3D = stage.stage3Ds[i];
                        if (stage3D)
                        {
                            return stage3D;
                        }
                        i = (i + 1);
                    }
                    if (!stage3D)
                    {
                        Logger.log(["Stage3D request error: no free instances available"]);
                        return null;
                    }
                }
                else
                {
                    Logger.log(["Stage3D request error: zero instances available"]);
                    return null;
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Logger.log([("Stage3D request error: " + e)]);
                return null;
            }
 }            return null;
        }
    }

