package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.tabbuttons
;
     class TabButtonConfig
    {
        var _tabId:Int = 0;
        var _assetUri:String;
        var _tooltipCaption:String;
        var _filteredVariables:ASFunction;

        public function new(tabId:Int, assetUri:String, tooltipCaption:String, filteredVariables:ASFunction)
        {
            this._tabId = tabId;
            this._assetUri = assetUri;
            this._tooltipCaption = tooltipCaption;
            this._filteredVariables = filteredVariables;
        }

        public var tabId(get,never):Int;
public function  get_tabId():Int { return this._tabId; }
        public var assetUri(get,never):String;
public function  get_assetUri():String { return this._assetUri; }
        public var tooltipCaption(get,never):String;
public function  get_tooltipCaption():String { return this._tooltipCaption; }
        public var filteredVariables(get,never):ASFunction;
public function  get_filteredVariables():ASFunction { return this._filteredVariables; }
    }

