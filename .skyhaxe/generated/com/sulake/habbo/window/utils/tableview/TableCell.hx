package com.sulake.habbo.window.utils.tableview
;
     class TableCell
    {
        public static inline final TYPE_TEXT= 0;
        public static inline final TYPE_LINK= 1;

        var _type:Int = 0;
        var _contents:ASObject;
        var _isInspectable:Bool = false;
        var _isEditable:Bool = false;
        var _textFieldValue:String;
        var _linkClickCallback:ASFunction;
        var _highlightOnChange:Bool = false;
        var _tooltipText:String;
        var _textColor:UInt = 0;
        var _extraBtn:String;
        var _extraBtnCallback:ASFunction;

        public function new(type:Int, contents:ASObject, isEditable:Bool=false, isInspectable:Bool=false, textFieldValue:String=null, linkClickCallback:ASFunction=null, highlightOnChange:Bool=false, tooltipText:String=null, textColor:UInt=0)
        {
            this._type = type;
            this._contents = contents;
            this._isEditable = isEditable;
            this._isInspectable = isInspectable;
            this._linkClickCallback = linkClickCallback;
            if ((textFieldValue == null) && (isEditable || isInspectable))
            {
                textFieldValue = ASCompat.asString(contents );
            }
            this._textFieldValue = textFieldValue;
            this._highlightOnChange = highlightOnChange;
            this._tooltipText = tooltipText;
            this._textColor = textColor;
        }

        public var type(get,never):Int;
public function  get_type():Int
        {
            return this._type;
        }

        public var contents(get,never):ASObject;
public function  get_contents():ASObject
        {
            return this._contents;
        }

        public var isEditable(get,never):Bool;
public function  get_isEditable():Bool
        {
            return this._isEditable;
        }

        public var isInspectable(get,never):Bool;
public function  get_isInspectable():Bool
        {
            return this._isInspectable;
        }

        public var textFieldValue(get,never):String;
public function  get_textFieldValue():String
        {
            return this._textFieldValue;
        }

        public var linkClickCallback(get,never):ASFunction;
public function  get_linkClickCallback():ASFunction
        {
            return this._linkClickCallback;
        }

        public var highlightOnChange(get,never):Bool;
public function  get_highlightOnChange():Bool
        {
            return this._highlightOnChange;
        }

        public var tooltipText(get,never):String;
public function  get_tooltipText():String
        {
            return this._tooltipText;
        }

        public var textColor(get,never):UInt;
public function  get_textColor():UInt
        {
            return this._textColor;
        }

        public function setExtraBtn(assetUri:String, callback:ASFunction)
        {
            this._extraBtn = assetUri;
            this._extraBtnCallback = callback;
        }

        public var extraBtn(get,never):String;
public function  get_extraBtn():String
        {
            return this._extraBtn;
        }

        public var extraBtnCallback(get,never):ASFunction;
public function  get_extraBtnCallback():ASFunction
        {
            return this._extraBtnCallback;
        }
    }

