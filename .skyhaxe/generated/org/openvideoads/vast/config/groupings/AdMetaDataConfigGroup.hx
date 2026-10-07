package org.openvideoads.vast.config.groupings
;
    import org.openvideoads.base.Debuggable;

     class AdMetaDataConfigGroup extends Debuggable 
    {
        var _Str_8619:LinearAdMetaDataConfig;

        public function new(k:ASObject=null)
        {
            this._Str_8619 = new LinearAdMetaDataConfig();
            super();
            this.initialise(k);
        }

        public function initialise(k:ASObject)
        {
            if (k != null)
            {
                if (k.linear != /*undefined*/null)
                {
                    this._Str_8619.initialise(k.linear);
                }
            }
        }

        public function _Str_19879(k:String="", _arg_2:String="0", _arg_3:Int=-1):String
        {
            if (this._Str_8619 != null)
            {
                return this._Str_8619._Str_25280(k, _arg_2, _arg_3);
            }
            return "";
        }

        public function _Str_19524(k:String="", _arg_2:String="0", _arg_3:Int=-1):String
        {
            if (this._Str_8619 != null)
            {
                return this._Str_8619._Str_23078(k, _arg_2, _arg_3);
            }
            return "";
        }
    }

