package com.sulake.habbo.friendbar.landingview.layout
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.utils.Map;
    import flash.events.EventDispatcher;
    import com.sulake.habbo.friendbar.landingview.layout.backgroundobjects._Str_5115;
    import com.sulake.habbo.friendbar.landingview.layout.backgroundobjects._Str_3317;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.friendbar.landingview.interfaces.elements.*;

     class MovingBackgroundObjects implements IDisposable implements  IUpdateReceiver 
    {
        static inline final _Str_18679= 20;

        var _landingView:HabboLandingView;
        var _objects:Array<ASAny>;
        var _objectTypeMap:Map;
        var _events:EventDispatcher;
        var _timingCode:String = "";

        public function new(k:HabboLandingView)
        {
            this._objects = [];
            this._objectTypeMap = new Map();
            this._events = new EventDispatcher();
            this._landingView = k;
            this._Str_23618();
        }

        function _Str_23618()
        {
            this._objectTypeMap.add(_Str_5115.LINEAR, _Str_5115._Str_18208);
            this._objectTypeMap.add(_Str_5115.SPIRAL, _Str_5115._Str_16125);
            this._objectTypeMap.add(_Str_5115.ANIMATED, _Str_5115._Str_17529);
            this._objectTypeMap.add(_Str_5115.RANDOMWALK, _Str_5115._Str_18412);
        }

        public function dispose()
        {
            var k:_Str_3317 = null;
            this._landingView = null;
            final _iter_ = this._objects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k.dispose();
            }
            this._objects = null;
            this._objectTypeMap.reset();
            this._objectTypeMap = null;
            this._events = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._landingView == null;
        }

        public function initialize(k:IWindowContainer)
        {
            var _local_3:String = null;
            var _local_4:_Str_3317 = null;
            k = cast(k.findChildByName("moving_objects_container"), IWindowContainer);
            if (k == null)
            {
                return;
            }
            if (this._objects.length > 0)
            {
                return;
            }
            var _local_2= 1;
            while (_local_2 <= _Str_18679)
            {
                if (this._timingCode == "")
                {
                    _local_3 = this._landingView.getProperty(("landing.view.bgobject." + Std.string(_local_2)));
                }
                else
                {
                    _local_3 = this._landingView.getProperty(((("landing.view." + this._timingCode) + ".bgobject.") + Std.string(_local_2)));
                }
                if (_local_3 != "")
                {
                    _local_4 = this._Str_22559(_local_2, _local_3, k);
                    if (_local_4 != null)
                    {
                        this._objects.push(_local_4);
                    }
                }
                _local_2++;
            }
        }

        public function update(k:UInt)
        {
            var _local_2:_Str_3317 = null;
            final _iter_ = this._objects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_2.update(k);
            }
        }

        function _Str_22559(k:Int, _arg_2:String, _arg_3:IWindowContainer):_Str_3317
        {
            var _local_5:String = null;
            var _local_6:Class<Dynamic> = null;
            var _local_4:Array<ASAny> = (cast _arg_2.split(";"));
            if (_local_4.length >= 2)
            {
                _local_5 = _local_4[1];
                _local_6 = this._objectTypeMap.getValue(_local_5);
                if (_local_6 != null)
                {
                    return Type.createInstance(_local_6, [k, _arg_3, this._events, this._landingView, _arg_2]);
                }
            }
            return null;
        }

        public var _Str_23132(never,set):String;
public function  set__Str_23132(k:String):String        {
            return this._timingCode = k;
        }
    }

