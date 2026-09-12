package com.sulake.habbo.window.utils
;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.window.graphics.renderer.ISkinRenderer;
    import com.sulake.core.window.utils.DefaultAttStruct;
    import com.sulake.core.window.utils.TypeCodeTable;
    import com.sulake.core.window.utils.StateCodeTable;
    import com.sulake.core.window.graphics.renderer.BitmapSkinRenderer;
    import com.sulake.core.window.graphics.renderer.BitmapDataRenderer;
    import com.sulake.core.window.graphics.renderer.FillSkinRenderer;
    import com.sulake.core.window.graphics.renderer.GradientSkinRenderer;
    import com.sulake.core.window.graphics.renderer.TextSkinRenderer;
    import com.sulake.core.window.graphics.renderer.LabelRenderer;
    import com.sulake.core.window.graphics.renderer.ShapeSkinRenderer;
    import com.sulake.core.window.graphics.renderer.SkinRenderer;
    import com.sulake.core.window.graphics.renderer.NullSkinRenderer;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.graphics.SkinContainer;

     class SkinParserUtil 
    {
        static inline final SKIN= "skin";
        static inline final BITMAP= "bitmap";
        static inline final FILL= "fill";
        static inline final GRADIENT= "gradient";
        static inline final TEXT= "text";
        static inline final LABEL= "label";
        static inline final SHAPE= "shape";
        static inline final UNKNOWN= "unknown";
        static inline final NULL= "null";


        public static function parse(k:com.sulake.core.utils.xml.XML, _arg_2:IAssetLibrary, _arg_3:SkinContainer)
        {
            var _local_9:com.sulake.core.utils.xml.XMLList = null;
            var _local_10:UInt = 0;
            var _local_11:com.sulake.core.utils.xml.XML = null;
            var _local_12:com.sulake.core.utils.xml.XMLList = null;
            var _local_13:String = null;
            var _local_14:String = null;
            var _local_15:UInt = 0;
            var _local_16:UInt = 0;
            var _local_17:String = null;
            var _local_18:String = null;
            var _local_19:IAsset = null;
            var _local_20:ISkinRenderer = null;
            var _local_21:String = null;
            var _local_22:Class<Dynamic> = null;
            var _local_23:DefaultAttStruct = null;
            var _local_24:Array<ASAny> = null;
            var _local_25:String = null;
            var _local_26:IAsset = null;
            var _local_27:com.sulake.core.utils.xml.XML = null;
            var _local_28:String = null;
            var _local_29:UInt = 0;
            var _local_30:IAsset = null;
            var _local_4= new ASDictionary<ASAny,ASAny>();
            var _local_5= new ASDictionary<ASAny,ASAny>();
            TypeCodeTable.fillTables(_local_4, _local_5);
            var _local_6= new ASDictionary<ASAny,ASAny>();
            var _local_7= new ASDictionary<ASAny,ASAny>();
            StateCodeTable.fillTables(_local_6, _local_7);
            var _local_8= new ASDictionary<ASAny,ASAny>();
            _local_8[SKIN] = BitmapSkinRenderer;
            _local_8[BITMAP] = BitmapDataRenderer;
            _local_8[FILL] = FillSkinRenderer;
            _local_8[GRADIENT] = GradientSkinRenderer;
            _local_8[TEXT] = TextSkinRenderer;
            _local_8[LABEL] = LabelRenderer;
            _local_8[SHAPE] = ShapeSkinRenderer;
            _local_8[UNKNOWN] = SkinRenderer;
            _local_8[NULL] = NullSkinRenderer;
            if (k != null)
            {
                _local_9 = k.child("window");
                _local_10 = _local_9.length();
                _local_24 = [];
                if (_local_10 > 0)
                {
                    _local_29 = 0;
                    while (_local_29 < _local_10)
                    {
                        _local_11 = _local_9.at(_local_29);
                        _local_13 = ASCompat.xmlListToString(_local_11.attribute("type"));
                        _local_28 = ASCompat.xmlListToString(_local_11.attribute("intent"));
                        _local_14 = ASCompat.xmlListToString(_local_11.attribute("style"));
                        _local_15 = ASCompat.asUint(_local_11.attribute("blend") );
                        _local_16 = ASCompat.asUint(_local_11.attribute("color") );
                        _local_17 = ASCompat.xmlListToString(_local_11.attribute("asset"));
                        _local_18 = ASCompat.xmlListToString(_local_11.attribute("layout"));
                        _local_25 = ASCompat.xmlListToString(_local_11.attribute("window_layout"));
                        _local_21 = ASCompat.xmlListToString(_local_11.attribute("renderer"));
                        _local_12 = _local_11.child("states");
                        _local_22 = _local_8[_local_21];
                        if (_local_22 != null)
                        {
                            _local_20 = Type.createInstance(_local_22, [_local_18]);
                            if (_local_20 != null)
                            {
                                _local_19 = _arg_2.getAssetByName(_local_17);
                                _local_20.parse(_local_19, _local_12, _arg_2);
                                if (((_local_19 != null) && (_local_24.indexOf(_local_19) == -1)))
                                {
                                    _local_24.push(_local_19);
                                }
                            }
                        }
                        _local_23 = new DefaultAttStruct();
                        _local_23.threshold = ASCompat.toUInt((_local_11.attribute("treshold").at(0) != null) ? ASCompat.toUInt(ASCompat.xmlToString(_local_11.attribute("treshold").at(0))) : 10);
                        _local_23.background = ((_local_11.attribute("background").at(0) != null) ? com.sulake.core.utils.xml.XML.equalsStringOperands(_local_11.attribute("background").at(0), "true") : false);
                        _local_23.blend = ((_local_11.attribute("blend").at(0) != null) ? ASCompat.toNumber(ASCompat.xmlToString(_local_11.attribute("blend").at(0))) : 1);
                        _local_23.color = ASCompat.toUInt((_local_11.attribute("color").at(0) != null) ? ASCompat.toUInt(ASCompat.xmlToString(_local_11.attribute("color").at(0))) : 0xFFFFFF);
                        _local_23.width_min = ((_local_11.attribute("width_min").at(0) != null) ? ASCompat.toInt(ASCompat.xmlToString(_local_11.attribute("width_min").at(0))) : ASCompat.MIN_INT);
                        _local_23.width_max = ((_local_11.attribute("width_max").at(0) != null) ? ASCompat.toInt(ASCompat.xmlToString(_local_11.attribute("width_max").at(0))) : ASCompat.MAX_INT);
                        _local_23.height_min = ((_local_11.attribute("height_min").at(0) != null) ? ASCompat.toInt(ASCompat.xmlToString(_local_11.attribute("height_min").at(0))) : ASCompat.MIN_INT);
                        _local_23.height_max = ((_local_11.attribute("height_max").at(0) != null) ? ASCompat.toInt(ASCompat.xmlToString(_local_11.attribute("height_max").at(0))) : ASCompat.MAX_INT);
                        _local_27 = null;
                        if (_local_25 != null)
                        {
                            _local_26 = _arg_2.getAssetByName(_local_25);
                            if (_local_26 != null)
                            {
                                _local_27 = ((_local_26.content : com.sulake.core.utils.xml.XML) );
                            }
                        }
                        _arg_3._Str_23324(ASCompat.toUInt(_local_4[_local_13]), ASCompat.toUInt(_local_14), _local_28, _local_20, _local_27, _local_23);
                        _local_29++;
                    }
                    if (checkNullIteratee(_local_24)) for (_tmp_ in _local_24)
                    {
_local_30  = _tmp_;
                        _local_30.dispose();
                    }
                }
            }
        }

	public function new() {}
    }


