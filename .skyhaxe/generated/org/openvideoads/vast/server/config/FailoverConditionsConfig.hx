package org.openvideoads.vast.server.config
;
    import org.openvideoads.base.Debuggable;

     class FailoverConditionsConfig extends Debuggable 
    {
        var _Str_9112:FailoverCondition = null;
        var _Str_6442:FailoverCondition = null;

        public function new(k:ASObject=null)
        {
            super();
            this.initialise(k);
        }

        public function initialise(k:ASObject)
        {
            if (k.onVPAIDError != /*undefined*/null)
            {
                this._Str_9112 = new FailoverCondition(k.onVPAIDError);
            }
            if (k.onStreamError != /*undefined*/null)
            {
                this._Str_6442 = new FailoverCondition(k.onStreamError);
            }
        }

        public function hasFailoverConditionOnVPAIDError():Bool
        {
            return !(this._Str_9112 == null);
        }

        
        public var onVPAIDError(get,set):FailoverCondition;
public function  set_onVPAIDError(k:FailoverCondition):FailoverCondition        {
            return this._Str_9112 = k;
        }
public function  get_onVPAIDError():FailoverCondition
        {
            return this._Str_9112;
        }

        public function _Str_26091():Bool
        {
            if (this._Str_9112 != null)
            {
                return this._Str_9112.always;
            }
            return false;
        }

        public function hasFailoverConditionOnStreamError():Bool
        {
            return !(this._Str_6442 == null);
        }

        
        public var onStreamError(get,set):FailoverCondition;
public function  set_onStreamError(k:FailoverCondition):FailoverCondition        {
            return this._Str_6442 = k;
        }
public function  get_onStreamError():FailoverCondition
        {
            return this._Str_6442;
        }

        public function _Str_26001():Bool
        {
            if (this._Str_6442 != null)
            {
                return this._Str_6442.always;
            }
            return false;
        }

        public function _Str_25963():Bool
        {
            if (this._Str_6442 != null)
            {
                return this._Str_6442._Str_20289();
            }
            return false;
        }
    }

