package org.openvideoads.vast.config.groupings
;
    import org.openvideoads.vast.config._Str_2741;
    import org.openvideoads.util.StringUtils;

     class DebugConfigGroup extends _Str_3389 
    {
        var _debugger:String = "firebug";
        var _levels:String = "fatal, config";

        public function new(k:ASObject=null, _arg_2:_Str_2741=null)
        {
            super(k, _arg_2);
        }

        override public function initialise(k:ASObject=null, _arg_2:_Str_2741=null, _arg_3:Bool=false)
        {
            _Str_3654();
            super.initialise(k, _arg_2);
            if (k != null)
            {
                if (k.levels != /*undefined*/null)
                {
                    this.levels = k.levels;
                }
                if (k.debugger != /*undefined*/null)
                {
                    this.debugger = k.debugger;
                }
            }
            _Str_3144();
        }

        public function _Str_16875():Bool
        {
            return !(this._debugger == null);
        }

        
        public var debugger(get,set):String;
public function  set_debugger(k:String):String        {
            return this._debugger = k;
        }
public function  get_debugger():String
        {
            return this._debugger;
        }

        
        public var levels(get,set):String;
public function  set_levels(k:String):String        {
            if (k != null)
            {
                if (!StringUtils.isEmpty(k))
                {
                    this._levels = k;
                }
            }
return k;
        }
public function  get_levels():String
        {
            return this._levels;
        }

        public function _Str_18288():Bool
        {
            return !(this._levels == null);
        }

        public function outputingDebug():Bool
        {
            return !(StringUtils.trim(this._levels).toUpperCase() == "NONE");
        }
    }

