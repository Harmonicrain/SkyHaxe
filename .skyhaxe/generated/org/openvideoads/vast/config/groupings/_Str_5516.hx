package org.openvideoads.vast.config.groupings
;
    import org.openvideoads.regions.config.RegionsConfig;
    import org.openvideoads.vast.config._Str_2741;

     class _Str_5516 extends RegionsConfig implements _Str_2741 
    {
        var _Str_4686:_Str_2741 = null;
        var _Str_3351:Bool = true;
        var _Str_8150:Bool = false;

        public function new(k:ASObject=null, _arg_2:_Str_2741=null)
        {
            super(k);
        }

        public function initialise(k:ASObject=null, _arg_2:_Str_2741=null)
        {
            this._Str_3654();
            this.setLoadedListener(_arg_2);
            setup(k);
            this._Str_3144();
        }

        public function setLoadedListener(k:_Str_2741)
        {
            this._Str_4686 = k;
        }

        public function _Str_17039():Bool
        {
            return !(this._Str_4686 == null);
        }

        public function _Str_6073():Bool
        {
            return this._Str_8150;
        }

        public function _Str_3654()
        {
            this._Str_8150 = true;
            this._Str_3351 = true;
        }

        public function _Str_3144()
        {
            this._Str_3351 = false;
            this._Str_8150 = false;
            this.onOVAConfigLoaded();
        }

        public function isOVAConfigLoading():Bool
        {
            return this._Str_3351;
        }

        public function onOVAConfigLoaded()
        {
            this._Str_3351 = false;
            if (this.isOVAConfigLoading() == false)
            {
                if (this._Str_17039())
                {
                    this._Str_4686.onOVAConfigLoaded();
                }
            }
        }
    }

