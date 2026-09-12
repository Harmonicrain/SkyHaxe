package com.sulake.habbo.freeflowchat.viewer.simulation
;
    import com.sulake.habbo.freeflowchat.viewer.visualization.style.IChatStyleInternal;
    import flash.display.Sprite;
    import flash.text.TextFormat;
    import flash.text.StyleSheet;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.Rectangle;

     class BlankStyle implements IChatStyleInternal 
    {
        public function getNewBackgroundSprite(k:UInt=0xFFFFFF):Sprite
        {
            var _local_2= new Sprite();
            _local_2.graphics.clear();
            _local_2.graphics.beginFill(0, 0);
            _local_2.graphics.drawRect(0, 0, 20, (ChatFlowStage._Str_7698 + ChatBubbleSimulationEntity._Str_13872));
            _local_2.graphics.endFill();
            return _local_2;
        }

        public var textFormat(get,never):TextFormat;
public function  get_textFormat():TextFormat
        {
            return new TextFormat();
        }

        public var styleSheet(get,never):StyleSheet;
public function  get_styleSheet():StyleSheet
        {
            return null;
        }

        public var pointer(get,never):BitmapData;
public function  get_pointer():BitmapData
        {
            return new BitmapData(1, 10, true, 0);
        }

        public var _Str_8470(get,never):Int;
public function  get__Str_8470():Int
        {
            return ChatFlowStage._Str_7698;
        }

        public var pointerOffsetToBubbleBottom(get,never):Int;
public function  get_pointerOffsetToBubbleBottom():Int
        {
            return this._Str_8470;
        }

        public function getPointerLeftMargin(k:Int):Int
        {
            return k;
        }

        public function getPointerRightMargin(k:Int):Int
        {
            return k;
        }

        public var _Str_5505(get,never):Point;
public function  get__Str_5505():Point
        {
            return null;
        }

        public var faceOffset(get,never):Point;
public function  get_faceOffset():Point
        {
            return this._Str_5505;
        }

        public function getEmblem(k:Bool=false):BitmapData
        {
            return null;
        }

        public function getEmblemOffset(k:Bool=false):Point
        {
            return null;
        }

        public var iconImage(get,never):BitmapData;
public function  get_iconImage():BitmapData
        {
            return null;
        }

        public var _Str_4931(get,never):Bool;
public function  get__Str_4931():Bool
        {
            return true;
        }

        public var isAnonymous(get,never):Bool;
public function  get_isAnonymous():Bool
        {
            return this._Str_4931;
        }

        public var isSystemStyle(get,never):Bool;
public function  get_isSystemStyle():Bool
        {
            return true;
        }

        public var textFieldMargins(get,never):Rectangle;
public function  get_textFieldMargins():Rectangle
        {
            return new Rectangle(0, 0, 0, 0);
        }

        public var overlap(get,never):Rectangle;
public function  get_overlap():Rectangle
        {
            return new Rectangle(0, 0, 0, 0);
        }

        public var allowHTML(get,never):Bool;
public function  get_allowHTML():Bool
        {
            return false;
        }

        public var isNotification(get,never):Bool;
public function  get_isNotification():Bool
        {
            return false;
        }
public function new(){}
    }

