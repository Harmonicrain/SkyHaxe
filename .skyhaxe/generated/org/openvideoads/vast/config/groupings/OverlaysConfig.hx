package org.openvideoads.vast.config.groupings
;
    import org.openvideoads.base.Debuggable;
    import org.openvideoads.vast.schedule.ads.templates.*;

     class OverlaysConfig extends Debuggable 
    {
        var _Str_17372:Bool = true;

        public function new(k:ASObject=null)
        {
            super();
            this.initialise(k);
        }

        public function initialise(k:ASObject)
        {
            if (k != null)
            {
                if (ASCompat.hasOwnProperty(k, "replay"))
                {
                    this.replay = k.replay;
                }
            }
        }

        
        public var replay(get,set):Bool;
public function  set_replay(k:ASAny):Bool        {
            if (Std.is(k , String))
            {
                this._Str_17372 = ((ASCompat.toString(k).toUpperCase() == "TRUE") ? true : false);
            }
            else
            {
                this._Str_17372 = k;
            }
return k;
        }
public function  get_replay():Bool
        {
            return this._Str_17372;
        }
    }

