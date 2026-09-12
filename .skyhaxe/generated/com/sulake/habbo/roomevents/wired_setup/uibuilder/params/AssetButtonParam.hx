package com.sulake.habbo.roomevents.wired_setup.uibuilder.params
;
     class AssetButtonParam
    {
        var _assetName:String;
        var _tooltip:String;
        var _onClick:ASFunction;
        var _isFollowedBySplitter:Bool = false;
        var _alignRight:Bool = false;

        public function new(_arg_1:String, _arg_2:String, _arg_3:ASFunction, _arg_4:Bool = false, _arg_5:Bool = false)
        {
            this._assetName = _arg_1;
            this._tooltip = _arg_2;
            this._onClick = _arg_3;
            this._isFollowedBySplitter = _arg_4;
            this._alignRight = _arg_5;
        }

        public var assetName(get,never):String;
public function  get_assetName():String { return this._assetName; }
        public var tooltip(get,never):String;
public function  get_tooltip():String { return this._tooltip; }
        public var onClick(get,never):ASFunction;
public function  get_onClick():ASFunction { return this._onClick; }
        public var isFollowedBySplitter(get,never):Bool;
public function  get_isFollowedBySplitter():Bool { return this._isFollowedBySplitter; }
        public var alignRight(get,never):Bool;
public function  get_alignRight():Bool { return this._alignRight; }
    }

