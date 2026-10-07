package org.openvideoads.regions
;
    import flash.display.Sprite;
    import org.openvideoads.regions.config.RegionsConfig;
    import org.openvideoads.util.Display;
    import org.openvideoads.regions.view.RegionView;
    import org.openvideoads.regions.config.CloseButtonConfig;
    import org.openvideoads.util.StringUtils;
    import org.openvideoads.regions.config.RegionViewConfig;
    import org.openvideoads.regions.events._Str_6326;
    import flash.events.MouseEvent;

     class RegionController extends Sprite 
    {
        var _Str_2297:RegionsConfig = null;
        var _Str_3178:Array<ASAny>;
        var _Str_2758:Display;
        var _Str_22774:Bool = false;
        public var _Str_15249:RegionView = null;

        public function new(k:Display, _arg_2:RegionsConfig)
        {
            this._Str_3178 = new Array<ASAny>();
            super();
            this._Str_2758 = k;
            this._Str_2297 = _arg_2;
            this.createRegionViews();
        }

        static function _Str_16801(k:String, _arg_2:Int=1)
        {
        }

        static function _Str_19580(k:ASObject, _arg_2:Int=1)
        {
        }


        var displayWidth(get,never):Float;
function  get_displayWidth():Float
        {
            if (this._Str_2758 != null)
            {
                return this._Str_2758.displayWidth;
            }
            return 0;
        }

        var displayHeight(get,never):Float;
function  get_displayHeight():Float
        {
            if (this._Str_2758 != null)
            {
                return this._Str_2758.displayHeight;
            }
            return 0;
        }

        var _Str_3712(get,never):CloseButtonConfig;
function  get__Str_3712():CloseButtonConfig
        {
            return (this._Str_2297 != null) ? this._Str_2297.closeButton : null;
        }

        var _Str_26134(get,never):Array<ASAny>;
function  get__Str_26134():Array<ASAny>
        {
            return this._Str_3178;
        }

        function _Str_2692(k:String):String
        {
            if (this._Str_22774)
            {
                return "#6F6F6F";
            }
            return k;
        }

        function _Str_3679(k:String, _arg_2:Bool=false):RegionView
        {
            var _local_3 = 0;
            while (_local_3 < this._Str_3178.length)
            {
                if (this._Str_3178[_local_3].id == k)
                {
                    if (_arg_2)
                    {
                        this._Str_3178.splice(_local_3, 1);
                    }
                    else
                    {
                        return this._Str_3178[_local_3];
                    }
                }
                _local_3++;
            }
            return this.createPredefinedRegion(k);
        }

        function _Str_25980(k:String, _arg_2:String):RegionView
        {
            var _local_3 = 0;
            while (_local_3 < this._Str_3178.length)
            {
                if (this._Str_3178[_local_3].id == k)
                {
                    if (this._Str_3178[_local_3].hasContentTypes())
                    {
                        if ((this._Str_3178[_local_3].contentTypes.toUpperCase() : ASAny).indexOf(_arg_2.toUpperCase()) > -1)
                        {
                            return this._Str_3178[_local_3];
                        }
                    }
                    else
                    {
                        return this._Str_3178[_local_3];
                    }
                }
                _local_3++;
            }
            return this.createPredefinedRegion(k);
        }

        function _Str_25103(k:String)
        {
            var _local_2 = 0;
            while (_local_2 < this._Str_3178.length)
            {
                if (this._Str_3178[_local_2].id == k)
                {
                    this._Str_3178.splice(_local_2, 1);
                }
                _local_2++;
            }
        }

        function createRegionViews()
        {
        }

        function createPredefinedRegion(k:String):RegionView
        {
            return this._Str_15249;
        }

        public function _Str_14006(k:String):Bool
        {
            if (k != null)
            {
                return k.toUpperCase().indexOf("AUTO") > -1;
            }
            return false;
        }

        public function _Str_15235(k:String):String
        {
            var _local_2:String = null;
            if (k != null)
            {
                if (((k.toUpperCase().indexOf("AUTO:") > -1) && (k.length > 5)))
                {
                    _local_2 = k.substr((k.toUpperCase().indexOf("AUTO:") + 5));
                    if (_local_2 != null)
                    {
                        _local_2 = StringUtils.trim(_local_2).toUpperCase();
                        if ("BOTTOM CENTER TOP".indexOf(_local_2) > -1)
                        {
                            return _local_2;
                        }
                    }
                }
            }
            return "BOTTOM";
        }

        function _Str_20101(k:String, _arg_2:Int, _arg_3:ASAny, _arg_4:String="BOTTOM", _arg_5:CloseButtonConfig=null, _arg_6:Bool=true, _arg_7:String=null, _arg_8:String=null, _arg_9:Float=-1, _arg_10:Float=-1, _arg_11:Bool=false, _arg_12:Bool=true):RegionView
        {
            this._Str_25103(k);
            return this._Str_2658(new RegionViewConfig({
                "id":k,
                "verticalAlign":_arg_4,
                "backgroundColor":this._Str_2692("transparent"),
                "horizontalAlign":"center",
                "padding":((_arg_8 != null) ? _arg_8 : "-10 -10 -10 -10"),
                "width":_arg_2,
                "height":_arg_3,
                "expandedWidth":_arg_9,
                "expandedHeight":_arg_10,
                "closeButton":((_arg_5 != null) ? _arg_5 : this._Str_3712),
                "clickable":_arg_6,
                "style":_arg_7,
                "autoSizing":true,
                "canScale":_arg_11,
                "autoHide":_arg_12
            }));
        }

        function newRegion(k:RegionController, _arg_2:RegionViewConfig, _arg_3:Display):RegionView
        {
            return new RegionView(this, _arg_2, this._Str_2758);
        }

        function _Str_2658(k:RegionViewConfig):RegionView
        {
            var _local_2= this.newRegion(this, k, this._Str_2758);
            this._Str_3178.push(_local_2);
            addChild(_local_2);
            this.setChildIndex(_local_2, (this.numChildren - 1));
            return _local_2;
        }

        public function _Str_9717()
        {
            var k = 0;
            while (k < this._Str_3178.length)
            {
                this._Str_3178[k].hide();
                k++;
            }
        }

        public function _Str_21107(k:Array<ASAny>)
        {
            var _local_2 = 0;
            var _local_3 = false;
            var _local_4 = 0;
            if (k != null)
            {
                _local_2 = 0;
                while (_local_2 < this._Str_3178.length)
                {
                    _local_3 = false;
                    _local_4 = 0;
                    while (((_local_4 < k.length) && (!_local_3)))
                    {
                        if (StringUtils._Str_2576(this._Str_3178[_local_2].id, k[_local_4].id))
                        {
                            _local_3 = true;
                        }
                        _local_4++;
                    }
                    if (!_local_3)
                    {
                        this._Str_3178[_local_2].hide();
                    }
                    _local_2++;
                }
            }
            else
            {
                this._Str_9717();
            }
        }

        public function onRegionCloseClicked(k:RegionView)
        {
        }

        public function onRegionClicked(k:RegionView, _arg_2:MouseEvent)
        {
            dispatchEvent(new _Str_6326(_Str_6326._Str_18707, k, _arg_2));
        }

        public function resize(k:Display)
        {
            this._Str_2758 = k;
            var _local_2 = 0;
            while (_local_2 < this._Str_3178.length)
            {
                this._Str_3178[_local_2].resize(k);
                _local_2++;
            }
        }

        public function _Str_19573(k:String, _arg_2:String):String
        {
            var _local_3= this._Str_3679(k);
            if (_local_3 != null)
            {
                _local_3.parseCSS(_arg_2);
                return "1, successfully passed to region to process";
            }
            return "-2, No region found for id: " + k;
        }
    }

