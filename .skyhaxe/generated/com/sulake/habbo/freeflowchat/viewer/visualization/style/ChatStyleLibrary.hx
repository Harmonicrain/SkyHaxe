package com.sulake.habbo.freeflowchat.viewer.visualization.style
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.freeflowchat.style.IChatStyleLibrary;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.utils.Map;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import flash.text.TextFormat;
    import flash.text.StyleSheet;
    import com.sulake.habbo.freeflowchat.style.IChatStyle;

     class ChatStyleLibrary implements IDisposable implements  IChatStyleLibrary 
    {
        static inline final _Str_22819= 0;

        var _assets:IAssetLibrary;
        var _styles:Map;

        public function new(assets:IAssetLibrary)
        {
            var child:com.sulake.core.utils.xml.XML = null;
            var styleId = 0;
            var assetId:String = null;
            var isSystemStyle = false;
            var isHcOnly = false;
            var isStaffOverrideable = false;
            var allowHtml = false;
            var isAmbassadorOnly = false;
            var purchasable = false;
            var isNotification = false;
            var style:ChatStyle = null;
            this._styles = new Map();
            this._assets = assets;
            var config= new com.sulake.core.utils.xml.XML(this._assets.getAssetByName("chatstyles_xml").content);
            final _iter_ = config.child("style"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
child  = _tmp_;
                styleId = ASCompat.toInt(child.attribute("id").at(0));
                assetId = ASCompat.xmlToString(child.attribute("assetId").at(0));
                isSystemStyle = com.sulake.core.utils.xml.XML.equalsStringOperands(child.attribute("systemStyle").at(0), "true");
                purchasable = com.sulake.core.utils.xml.XML.equalsStringOperands(child.attribute("purchasable").at(0), "true");
                isHcOnly = com.sulake.core.utils.xml.XML.equalsStringOperands(child.attribute("hcOnly").at(0), "true");
                isStaffOverrideable = com.sulake.core.utils.xml.XML.equalsStringOperands(child.attribute("staffOverrideable").at(0), "true");
                allowHtml = com.sulake.core.utils.xml.XML.equalsStringOperands(child.attribute("allowHTML").at(0), "true");
                isAmbassadorOnly = com.sulake.core.utils.xml.XML.equalsStringOperands(child.attribute("ambassadorOnly").at(0), "true");
                isNotification = com.sulake.core.utils.xml.XML.equalsStringOperands(child.attribute("notification").at(0), "true");
                try
                {
                    style = this._Str_22503(assetId, isSystemStyle, purchasable, isHcOnly, isStaffOverrideable, allowHtml, isAmbassadorOnly, isNotification);
                    this._styles.add(styleId, style);
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                    Logger.log([((("Error initializing chat style: " + Std.string(styleId)) + ", error message: ") + e.message)]);
                }
 }            }
        }

        public function dispose()
        {
            this._styles.dispose();
            this._styles = null;
            this._assets = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._assets == null;
        }

        function _Str_22503(k:String, _arg_2:Bool, _arg_3:Bool, _arg_4:Bool, _arg_5:Bool, _arg_6:Bool, _arg_7:Bool, _arg_8:Bool):ChatStyle
        {
            var _local_11:BitmapData = null;
            var _local_31:Array<ASAny> = null;
            var _local_7= ASCompat.toString(this._assets.getAssetByName((("style_" + k) + "_regpoints")).content);
            var _local_8= ASCompat.dynamicAs(this._assets.getAssetByName((("style_" + k) + "_chat_bubble_base")).content , BitmapData);
            var _local_9= new Rectangle(this._Str_8491(_local_7, "9sliceXY").x, this._Str_8491(_local_7, "9sliceXY").y, this._Str_8491(_local_7, "9sliceWH").x, this._Str_8491(_local_7, "9sliceWH").y);
            var _local_10:Point = (this._Str_5585(_local_7, "faceXY") ? this._Str_8491(_local_7, "faceXY") : null);
            var _local_12 = 0;
            var _local_13= (this._Str_5585(_local_7, "anonymous") ? this._Str_22452(_local_7, "anonymous") : false);
            if (!_local_13)
            {
                _local_11 = ASCompat.dynamicAs(this._assets.getAssetByName((("style_" + k) + "_chat_bubble_pointer")).content , BitmapData);
                _local_12 = ASCompat.toInt(this._Str_4292(_local_7, "pointerY")[0]);
                _local_31 = (this._Str_5585(_local_7, "pointerXMargins") ? this._Str_10570(_local_7, "pointerXMargins") : null);
            }
            var _local_32:BitmapData = null;
            var _local_33:Point = null;
            if ((this._Str_5585(_local_7, "emblemXY") && this._assets.hasAsset((("style_" + k) + "_chat_bubble_emblem"))))
            {
                _local_32 = ASCompat.dynamicAs(this._assets.getAssetByName((("style_" + k) + "_chat_bubble_emblem")).content , BitmapData);
                _local_33 = this._Str_8491(_local_7, "emblemXY");
            }
            var _local_34:BitmapData = null;
            var _local_35:Point = null;
            if ((this._Str_5585(_local_7, "emblemMultilineXY") && this._assets.hasAsset((("style_" + k) + "_chat_bubble_emblem_multiline"))))
            {
                _local_34 = ASCompat.dynamicAs(this._assets.getAssetByName((("style_" + k) + "_chat_bubble_emblem_multiline")).content , BitmapData);
                _local_35 = this._Str_8491(_local_7, "emblemMultilineXY");
            }
            var _local_14:BitmapData = (this._assets.hasAsset((("style_" + k) + "_icon")) ? ASCompat.dynamicAs(this._assets.getAssetByName((("style_" + k) + "_icon")).content , BitmapData) : null);
            var _local_15= this._Str_19117(_local_7, "textFieldMargins");
            var _local_16= ASCompat.dynamicAs(this._assets.getAssetByName((("style_" + k) + "_selector_preview")).content , BitmapData);
            var _local_17:BitmapData = null;
            if (this._assets.hasAsset((("style_" + k) + "_chat_bubble_color")))
            {
                _local_17 = ASCompat.dynamicAs(this._assets.getAssetByName((("style_" + k) + "_chat_bubble_color")).content , BitmapData);
            }
            var _local_18:Point = (this._Str_5585(_local_7, "colorXY") ? this._Str_8491(_local_7, "colorXY") : null);
            var _local_19:Rectangle = (this._Str_5585(_local_7, "overlapRect") ? this._Str_19117(_local_7, "overlapRect") : null);
            var _local_20= ASCompat.toUInt(this._Str_5585(_local_7, "textColorRGB") ? ASCompat.toUInt(this._Str_4292(_local_7, "textColorRGB")[0]) : 0);
            var _local_21= (this._Str_5585(_local_7, "fontFace") ? this._Str_4292(_local_7, "fontFace")[0] : "Volter");
            var _local_22= (this._Str_5585(_local_7, "fontSize") ? ASCompat.toInt(this._Str_4292(_local_7, "fontSize")[0]) : 9);
            var _local_23= new TextFormat(_local_21, _local_22, ASCompat.toInt(_local_20));
            var _local_24= (this._Str_5585(_local_7, "linkColorRGB") ? ASCompat.toUInt(this._Str_4292(_local_7, "linkColorRGB")[0]) : _local_20);
            var _local_25= (this._Str_5585(_local_7, "linkHoverColorRGB") ? ASCompat.toUInt(this._Str_4292(_local_7, "linkHoverColorRGB")[0]) : _local_20);
            var _local_26= (this._Str_5585(_local_7, "linkActiveColorRGB") ? ASCompat.toUInt(this._Str_4292(_local_7, "linkActiveColorRGB")[0]) : _local_20);
            var _local_27= new StyleSheet();
            var _local_28:ASObject = new ASObject();
            _local_28.textDecoration = "underline";
            _local_28.color = this._Str_5520(_local_24);
            _local_27.setStyle("a:link", _local_28);
            var _local_29:ASObject = new ASObject();
            _local_29.color = this._Str_5520(_local_26);
            _local_27.setStyle("a:active", _local_29);
            var _local_30:ASObject = new ASObject();
            _local_30.color = this._Str_5520(_local_25);
            _local_27.setStyle("a:hover", _local_30);
            var _local_36= (this._Str_5585(_local_7, "usePixelPerfectNineSlice") ? this._Str_22452(_local_7, "usePixelPerfectNineSlice") : false);
            return new ChatStyle(_local_8, _local_9, _local_11, _local_12, _local_31, _local_15, _local_23, _local_13, _local_32, _local_33, _local_34, _local_35, _local_10, _local_14, _local_16, _arg_2, _arg_3, _arg_4, _arg_5, _arg_7, _arg_8, _local_17, _local_18, _local_19, _arg_6, _local_27, _local_36);
        }

        function _Str_5520(k:UInt):String
        {
            var _local_2= ASCompat.toRadix(k, 16);
            while (_local_2.length < 6)
            {
                _local_2 = ("0" + _local_2);
            }
            return "#" + _local_2;
        }

        function _Str_5585(k:String, _arg_2:String):Bool
        {
            return !(k.indexOf(_arg_2) == -1);
        }

        function _Str_4292(k:String, _arg_2:String):Array<ASAny>
        {
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6 = false;
            var _local_7:String = null;
            var _local_3= k.indexOf(_arg_2);
            if (_local_3 != -1)
            {
                _local_4 = k.indexOf("=", _local_3);
                _local_5 = k.indexOf("\r\n", _local_4);
                if (_local_5 == -1)
                {
                    _local_5 = k.indexOf("\n", _local_4);
                }
                if (_local_5 == -1)
                {
                    _local_5 = k.length;
                }
                _local_6 = (k.charAt((_local_4 + 1)) == " ");
                _local_7 = k.substr((_local_4 + (_local_6 ? 2 : 1)), ((_local_5 - _local_4) - (_local_6 ? 2 : 1)));
                return (cast _local_7.split(","));
            }
            return null;
        }

        function _Str_8491(k:String, _arg_2:String):Point
        {
            return new Point(ASCompat.toInt(this._Str_4292(k, _arg_2)[0]), ASCompat.toInt(this._Str_4292(k, _arg_2)[1]));
        }

        function _Str_10570(k:String, _arg_2:String):Array<ASAny>
        {
            var _local_4:String = null;
            var _local_3:Array<ASAny> = [];
            final _iter_ = this._Str_4292(k, _arg_2); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = _tmp_;
                _local_3.push(ASCompat.toInt(_local_4));
            }
            return _local_3;
        }

        function _Str_19117(k:String, _arg_2:String):Rectangle
        {
            return new Rectangle(ASCompat.toInt(this._Str_4292(k, _arg_2)[0]), ASCompat.toInt(this._Str_4292(k, _arg_2)[1]), ASCompat.toInt(this._Str_4292(k, _arg_2)[2]), ASCompat.toInt(this._Str_4292(k, _arg_2)[3]));
        }

        function _Str_22452(k:String, _arg_2:String):Bool
        {
            return this._Str_4292(k, _arg_2)[0] == "true";
        }

        public function getStyleIds():Array<ASAny>
        {
            return this._styles.getKeys();
        }

        public function getStyle(k:Int):IChatStyle
        {
            if (this._styles.hasKey(k))
            {
                return this._styles.getValue(k);
            }
            return this._styles.getValue(ChatStyleLibrary._Str_22819);
        }
    }

