package org.openvideoads.regions.config
;
     class RegionsConfig extends BaseRegionConfig 
    {
        var _Str_21912:Bool = false;
        var _Str_3908:Array<ASAny>;
        var _Str_26159:String = null;

        public function new(k:ASObject=null)
        {
            this._Str_3908 = new Array<ASAny>();
            super(k);
        }

        override public function setup(k:ASObject)
        {
            super.setup(k);
            id = "master";
            if (k != null)
            {
                if (ASCompat.hasOwnProperty(k, "declarations"))
                {
                    this.regions = k.declarations;
                }
                if (k.closeButton != /*undefined*/null)
                {
                    closeButton = new CloseButtonConfig(k.closeButton);
                }
            }
        }

        public function hasRegionDefinitions():Bool
        {
            return this._Str_3908.length > 0;
        }

        
        public var _Str_23185(get,set):Bool;
public function  set__Str_23185(k:Bool):Bool        {
            return this._Str_21912 = k;
        }
public function  get__Str_23185():Bool
        {
            return this._Str_21912;
        }

        
        public var regions(get,set):Array<ASAny>;
public function  set_regions(k:Array<ASAny>):Array<ASAny>        {
            var _local_2 = 0;
            var _local_3:RegionViewConfig = null;
            this._Str_3908 = new Array<ASAny>();
            if (k != null)
            {
                _local_2 = 0;
                while (_local_2 < k.length)
                {
                    _local_3 = new RegionViewConfig(properties);
                    _local_3.setup(k[_local_2]);
                    this._Str_3908.push(_local_3);
                    _local_2++;
                }
            }
return k;
        }
public function  get_regions():Array<ASAny>
        {
            return this._Str_3908;
        }
    }

