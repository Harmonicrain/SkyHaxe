package org.openvideoads.vast.server.config
;
    import org.openvideoads.base.Debuggable;

     class FailoverCondition extends Debuggable 
    {
        var _Str_16802:Bool = false;
        var _Str_11489:Array<ASAny> = null;

        public function new(k:ASObject=null)
        {
            super();
            this.initialise(k);
        }

        public function initialise(k:ASObject=null)
        {
            if (k != null)
            {
                if (k.always != /*undefined*/null)
                {
                    if (Std.is(k.always , String))
                    {
                        this.always = ((k.always.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this.always = k.always;
                    }
                }
                if (k.rules != /*undefined*/null)
                {
                    if (Std.is(k.rules , Array))
                    {
                        this.rules = k.rules;
                    }
                }
            }
        }

        
        public var always(get,set):Bool;
public function  set_always(k:Bool):Bool        {
            return this._Str_16802 = k;
        }
public function  get_always():Bool
        {
            return this._Str_16802;
        }

        public function _Str_20289():Bool
        {
            if (this._Str_11489 != null)
            {
                return this._Str_11489.length > 0;
            }
            return false;
        }

        
        public var rules(get,set):Array<ASAny>;
public function  set_rules(k:Array<ASAny>):Array<ASAny>        {
            return this._Str_11489 = k;
        }
public function  get_rules():Array<ASAny>
        {
            return this._Str_11489;
        }

        public function shouldFailover(k:String):Bool
        {
            var _local_2 = 0;
            if (this._Str_16802)
            {
                if (this._Str_20289())
                {
                    if (k != null)
                    {
                        _local_2 = 0;
                        while (_local_2 < this._Str_11489.length)
                        {
                            if (k.indexOf(this.rules[_local_2]) > -1)
                            {
                                return true;
                            }
                            _local_2++;
                        }
                    }
                }
                else
                {
                    return true;
                }
            }
            return false;
        }
    }

