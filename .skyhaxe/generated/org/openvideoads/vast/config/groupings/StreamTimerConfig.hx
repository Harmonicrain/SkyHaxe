package org.openvideoads.vast.config.groupings
;
    import org.openvideoads.base.Debuggable;

     class StreamTimerConfig extends Debuggable 
    {
        var _Str_2699:Bool = false;
        var _Str_18281:Float = 100;
        var _Str_16130:Float = 100000;

        public function new(k:ASObject=null)
        {
            super();
            if (k != null)
            {
                this.initialise(k);
            }
        }

        public function initialise(k:ASObject)
        {
            if (k != null)
            {
                if (k.enabled != /*undefined*/null)
                {
                    if (Std.is(k.enabled , String))
                    {
                        this._Str_2699 = (k.enabled.toUpperCase() == "TRUE");
                    }
                    else
                    {
                        this._Str_2699 = k.enabled;
                    }
                }
                if (k.tickRate != /*undefined*/null)
                {
                    this._Str_18281 = ASCompat.toNumber(k.tickRate);
                }
                if (k.cycles != /*undefined*/null)
                {
                    this._Str_16130 = ASCompat.toNumber(k.cycles);
                }
            }
        }

        
        public var enabled(get,set):Bool;
public function  set_enabled(k:Bool):Bool        {
            return this._Str_2699 = k;
        }
public function  get_enabled():Bool
        {
            return this._Str_2699;
        }

        
        public var tickRate(get,set):Float;
public function  set_tickRate(k:Float):Float        {
            return this._Str_18281 = k;
        }
public function  get_tickRate():Float
        {
            return this._Str_18281;
        }

        
        public var cycles(get,set):Float;
public function  set_cycles(k:Float):Float        {
            return this._Str_16130 = k;
        }
public function  get_cycles():Float
        {
            return this._Str_16130;
        }
    }

