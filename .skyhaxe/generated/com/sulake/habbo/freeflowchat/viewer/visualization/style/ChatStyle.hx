package com.sulake.habbo.freeflowchat.viewer.visualization.style
;
    import com.sulake.habbo.freeflowchat.style.IChatStyle;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.text.TextFormat;
    import flash.geom.Point;
    import flash.text.StyleSheet;
    import flash.geom.ColorTransform;
    import flash.display.BlendMode;
    import com.sulake.habbo.freeflowchat.HabboFreeFlowChat;
    import flash.display.Sprite;

     class ChatStyle implements IChatStyle implements  IChatStyleInternal 
    {
        var _background:BitmapData;
        var _scale9Grid:Rectangle;
        var _pointer:BitmapData;
        var _pointerY:Int = 0;
        var _pointerXMargins:Array<ASAny>;
        var _textFieldMargins:Rectangle;
        var _textFormat:TextFormat;
        var _emblemImage:BitmapData;
        var _emblemOffset:Point;
        var _multilineEmblemImage:BitmapData;
        var _multilineEmblemOffset:Point;
        var _iconImage:BitmapData;
        var _iconOffset:Point;
        var _selectorPreview:BitmapData;
        var _color:BitmapData;
        var _colorOffset:Point;
        var _overlap:Rectangle;
        var _isSystemStyle:Bool = false;
        var _isHcOnly:Bool = false;
        var _isAmbassadorOnly:Bool = false;
        var _isStaffOverrideable:Bool = false;
        var _purchasable:Bool = false;
        var _isNotification:Bool = false;
        var _isAnonymous:Bool = false;
        var _allowHTML:Bool = false;
        var _styleSheet:StyleSheet;
        var _usePixelPerfectNineSlice:Bool = false;

        public function new(k:BitmapData, _arg_2:Rectangle, _arg_3:BitmapData, _arg_4:Int, _arg_5:Array<ASAny>, _arg_6:Rectangle, _arg_7:TextFormat, _arg_8:Bool, _arg_9:BitmapData, _arg_10:Point, _arg_11:BitmapData, _arg_12:Point, _arg_13:Point, _arg_14:BitmapData, _arg_15:BitmapData, _arg_16:Bool, _arg_17:Bool, _arg_18:Bool, _arg_19:Bool, _arg_20:Bool, _arg_21:Bool, _arg_22:BitmapData=null, _arg_23:Point=null, _arg_24:Rectangle=null, _arg_25:Bool=false, _arg_26:StyleSheet=null, _arg_27:Bool=false)
        {
            this._background = k;
            this._scale9Grid = _arg_2;
            this._pointer = _arg_3;
            this._pointerY = _arg_4;
            this._pointerXMargins = _arg_5;
            this._textFieldMargins = _arg_6;
            this._textFormat = _arg_7;
            this._isAnonymous = _arg_8;
            this._emblemImage = _arg_9;
            this._emblemOffset = _arg_10;
            this._multilineEmblemImage = _arg_11;
            this._multilineEmblemOffset = _arg_12;
            this._iconOffset = _arg_13;
            this._iconImage = _arg_14;
            this._selectorPreview = _arg_15;
            this._isSystemStyle = _arg_16;
            this._purchasable = _arg_17;
            this._isHcOnly = _arg_18;
            this._isStaffOverrideable = _arg_19;
            this._isAmbassadorOnly = _arg_20;
            this._isNotification = _arg_21;
            this._color = _arg_22;
            this._colorOffset = _arg_23;
            this._overlap = _arg_24;
            this._allowHTML = _arg_25;
            this._styleSheet = _arg_26;
            this._usePixelPerfectNineSlice = _arg_27;
        }

        public function getNewBackgroundSprite(k:UInt=0xFFFFFF):Sprite
        {
            var _local_2:BitmapData = null;
            var _local_3:UInt = 0;
            var _local_4:UInt = 0;
            var _local_5:UInt = 0;
            if (this._color != null)
            {
                _local_2 = new BitmapData(this._background.width, this._background.height, this._background.transparent, 0);
                _local_2.copyPixels(this._background, this._background.rect, new Point(0, 0));
                _local_3 = ((ASCompat.toInt(k )>> 16) & 0xFF);
                _local_4 = ((ASCompat.toInt(k )>> 8) & 0xFF);
                _local_5 = ((ASCompat.toInt(k )>> 0) & 0xFF);
                _local_2.draw(this._color, null, new ColorTransform((_local_3 / 0xFF), (_local_4 / 0xFF), (_local_5 / 0xFF)), BlendMode.DARKEN);
            }
            else
            {
                _local_2 = this._background;
            }
            return this._usePixelPerfectNineSlice ? HabboFreeFlowChat.createPixelPerfect9SliceSprite(this._scale9Grid, _local_2) : HabboFreeFlowChat.create9SliceSprite(this._scale9Grid, _local_2);
        }

        public var textFormat(get,never):TextFormat;
public function  get_textFormat():TextFormat
        {
            return this._textFormat;
        }

        public var styleSheet(get,never):StyleSheet;
public function  get_styleSheet():StyleSheet
        {
            return this._styleSheet;
        }

        public var pointer(get,never):BitmapData;
public function  get_pointer():BitmapData
        {
            return this._pointer;
        }

        public var _Str_8470(get,never):Int;
public function  get__Str_8470():Int
        {
            return this._background.height - this._pointerY;
        }

        public var pointerOffsetToBubbleBottom(get,never):Int;
public function  get_pointerOffsetToBubbleBottom():Int
        {
            return this._Str_8470;
        }

        public function getPointerLeftMargin(k:Int):Int
        {
            if (this._pointerXMargins == null || this._pointerXMargins.length < 1)
            {
                return k;
            }
            return ASCompat.toInt(this._pointerXMargins[0]);
        }

        public function getPointerRightMargin(k:Int):Int
        {
            if (this._pointerXMargins == null || this._pointerXMargins.length < 2)
            {
                return k;
            }
            return ASCompat.toInt(this._pointerXMargins[1]);
        }

        public var _Str_4931(get,never):Bool;
public function  get__Str_4931():Bool
        {
            return this._isAnonymous;
        }

        public var isAnonymous(get,never):Bool;
public function  get_isAnonymous():Bool
        {
            return this._isAnonymous;
        }

        public var _Str_5505(get,never):Point;
public function  get__Str_5505():Point
        {
            return this._iconOffset;
        }

        public var faceOffset(get,never):Point;
public function  get_faceOffset():Point
        {
            return this._iconOffset;
        }

        public function getEmblem(k:Bool=false):BitmapData
        {
            if (k && this._multilineEmblemImage != null && this._multilineEmblemOffset != null)
            {
                return this._multilineEmblemImage;
            }
            return this._emblemOffset != null ? this._emblemImage : null;
        }

        public function getEmblemOffset(k:Bool=false):Point
        {
            if (k && this._multilineEmblemImage != null && this._multilineEmblemOffset != null)
            {
                return this._multilineEmblemOffset;
            }
            return this._emblemOffset;
        }

        public var icon(get,never):BitmapData;
public function  get_icon():BitmapData
        {
            return this._iconImage;
        }

        public var iconImage(get,never):BitmapData;
public function  get_iconImage():BitmapData
        {
            return this._iconImage;
        }

        public var textFieldMargins(get,never):Rectangle;
public function  get_textFieldMargins():Rectangle
        {
            return this._textFieldMargins;
        }

        public var overlap(get,never):Rectangle;
public function  get_overlap():Rectangle
        {
            return this._overlap;
        }

        public var selectorPreview(get,never):BitmapData;
public function  get_selectorPreview():BitmapData
        {
            return this._selectorPreview;
        }

        public var isSystemStyle(get,never):Bool;
public function  get_isSystemStyle():Bool
        {
            return this._isSystemStyle;
        }

        public var isHcOnly(get,never):Bool;
public function  get_isHcOnly():Bool
        {
            return this._isHcOnly;
        }

        public var purchasable(get,never):Bool;
public function  get_purchasable():Bool
        {
            return this._purchasable;
        }

        public var isAmbassadorOnly(get,never):Bool;
public function  get_isAmbassadorOnly():Bool
        {
            return this._isAmbassadorOnly;
        }

        public var isStaffOverrideable(get,never):Bool;
public function  get_isStaffOverrideable():Bool
        {
            return this._isStaffOverrideable;
        }

        public var allowHTML(get,never):Bool;
public function  get_allowHTML():Bool
        {
            return this._allowHTML;
        }

        public var isNotification(get,never):Bool;
public function  get_isNotification():Bool
        {
            return this._isNotification;
        }
    }

