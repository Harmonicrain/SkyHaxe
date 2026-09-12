package com.sulake.core.window.motion
;
    import flash.utils.Timer;
    import com.sulake.core.Core;
    import com.sulake.core.window.IWindow;
    import flash.events.TimerEvent;
@:build(skyhaxe.assets.DeferredStaticMacro.build("_Str_5307"))

     class Motions 
    {
        static final _Str_5358:Vector<Motion> = new Vector();
        static final _Str_3932:Vector<Motion> = new Vector();
        static final _Str_10731:Vector<Motion> = new Vector();
        static final _Str_5307:Timer = new Timer((1000 / Core.instance.displayObjectContainer.stage.frameRate), 0);
        static var _Str_7507:Bool = false;


        public static function _Str_4598(k:Motion):Motion
        {
            if (((_Str_3932.indexOf(k) == -1) && (_Str_5358.indexOf(k) == -1)))
            {
                if (_Str_7507)
                {
                    _Str_5358.push(k);
                }
                else
                {
                    _Str_3932.push(k);
                    k.start();
                }
                _Str_12757();
            }
            return k;
        }

        public static function _Str_15790(k:Motion)
        {
            var _local_2= _Str_3932.indexOf(k);
            if (_local_2 > -1)
            {
                if (_Str_7507)
                {
                    _local_2 = _Str_10731.indexOf(k);
                    if (_local_2 == -1)
                    {
                        _Str_10731.push(k);
                    }
                }
                else
                {
                    _Str_3932.splice(_local_2, 1);
                    if (k.running)
                    {
                        k.stop();
                    }
                    if (_Str_3932.length == 0)
                    {
                        _Str_7465();
                    }
                }
            }
            else
            {
                _local_2 = _Str_5358.indexOf(k);
                if (_local_2 > -1)
                {
                    _Str_5358.splice(_local_2, 1);
                }
            }
        }

        public static function _Str_19320(k:String):Motion
        {
            var _local_2:Motion = null;
            final _iter_ = _Str_3932; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.tag == k)
                {
                    return _local_2;
                }
            }
            final _iter_ = _Str_5358; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.tag == k)
                {
                    return _local_2;
                }
            }
            return null;
        }

        public static function _Str_9810(k:IWindow):Motion
        {
            var _local_2:Motion = null;
            final _iter_ = _Str_3932; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.target == k)
                {
                    return _local_2;
                }
            }
            final _iter_ = _Str_5358; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.target == k)
                {
                    return _local_2;
                }
            }
            return null;
        }

        public static function _Str_26365(k:String, _arg_2:IWindow):Motion
        {
            var _local_3:Motion = null;
            final _iter_ = _Str_3932; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                if (((_local_3.tag == k) && (_local_3.target == _arg_2)))
                {
                    return _local_3;
                }
            }
            final _iter_ = _Str_5358; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                if (((_local_3.tag == k) && (_local_3.target == _arg_2)))
                {
                    return _local_3;
                }
            }
            return null;
        }

        public static var isRunning(get,never):Bool;
public static function  get_isRunning():Bool
        {
            return (_Str_5307 != null) ? _Str_5307.running : false;
        }

        public static var _Str_26314(get,never):Bool;
public static function  get__Str_26314():Bool
        {
            return _Str_7507;
        }

        static function _Str_21055(k:TimerEvent)
        {
            var _local_3:Motion = null;
            _Str_7507 = true;
            var _local_2= flash.Lib.getTimer();
            while ((_local_3 = _Str_5358.pop()) != null)
            {
                _Str_3932.push(_local_3);
            }
            while ((_local_3 = _Str_10731.pop()) != null)
            {
                _Str_3932.splice(_Str_3932.indexOf(_local_3), 1);
                if (_local_3.running)
                {
                    _local_3.stop();
                }
            }
            final _iter_ = _Str_3932; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                if (_local_3.running)
                {
                    _local_3.tick(_local_2);
                    if (_local_3.complete)
                    {
                        _Str_15790(_local_3);
                    }
                }
                else
                {
                    _Str_15790(_local_3);
                }
            }
            if (_Str_3932.length == 0)
            {
                _Str_7465();
            }
            _Str_7507 = false;
        }

        static function _Str_12757()
        {
            if (!_Str_5307.running)
            {
                _Str_5307.addEventListener(TimerEvent.TIMER, (_Str_21055 : ASAny));
                _Str_5307.start();
            }
        }

        static function _Str_7465()
        {
            if (_Str_5307.running)
            {
                _Str_5307.removeEventListener(TimerEvent.TIMER, (_Str_21055 : ASAny));
                _Str_5307.stop();
            }
        }


        public function _Str_25883(k:IWindow):Int
        {
            var _local_3:Motion = null;
            var _local_2 = 0;
            final _iter_ = _Str_3932; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                if (_local_3.target == k)
                {
                    _local_2++;
                }
            }
            return _local_2;
        }

	public function new() {}
    }

