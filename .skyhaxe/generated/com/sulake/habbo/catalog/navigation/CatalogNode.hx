package com.sulake.habbo.catalog.navigation
;
    import com.sulake.habbo.communication.messages.incoming.catalog.NodeData;

     class CatalogNode implements ICatalogNode 
    {
        static inline final ICON_= "icon_";

        var _depth:Int = 0;
        var _localization:String = "";
        var _pageId:Int = -1;
        var _pageName:String = "";
        var _iconId:Int = 0;
        var _children:Vector<ICatalogNode>;
        var _offerIds:Vector<Int>;
        var _navigator:ICatalogNavigator;
        var _parent:ICatalogNode;

        public function new(k:ICatalogNavigator, _arg_2:NodeData, _arg_3:Int, _arg_4:ICatalogNode)
        {
            this._depth = _arg_3;
            this._parent = _arg_4;
            this._navigator = k;
            this._localization = _arg_2.localization;
            this._pageId = _arg_2.pageId;
            this._pageName = _arg_2.pageName;
            this._iconId = _arg_2.icon;
            this._children = new Vector<ICatalogNode>(0);
            this._offerIds = _arg_2.pageOffers;
        }

        public var isOpen(get,never):Bool;
public function  get_isOpen():Bool
        {
            return false;
        }

        public var depth(get,never):Int;
public function  get_depth():Int
        {
            return this._depth;
        }

        public var isBranch(get,never):Bool;
public function  get_isBranch():Bool
        {
            return this._children.length > 0;
        }

        public var isLeaf(get,never):Bool;
public function  get_isLeaf():Bool
        {
            return this._children.length == 0;
        }

        public var visible(get,never):Bool;
public function  get_visible():Bool
        {
            return false;
        }

        public var localization(get,never):String;
public function  get_localization():String
        {
            return this._localization;
        }

        public var pageId(get,never):Int;
public function  get_pageId():Int
        {
            return this._pageId;
        }

        public var pageName(get,never):String;
public function  get_pageName():String
        {
            return this._pageName;
        }

        public var children(get,never):Vector<ICatalogNode>;
public function  get_children():Vector<ICatalogNode>
        {
            return this._children;
        }

        public var offerIds(get,never):Vector<Int>;
public function  get_offerIds():Vector<Int>
        {
            return this._offerIds;
        }

        public var navigator(get,never):ICatalogNavigator;
public function  get_navigator():ICatalogNavigator
        {
            return this._navigator;
        }

        
        public var parent(get,set):ICatalogNode;
public function  get_parent():ICatalogNode
        {
            return this._parent;
        }
public function  set_parent(k:ICatalogNode):ICatalogNode        {
return k;
        }

        public function dispose()
        {
            var k:ICatalogNode = null;
            final _iter_ = this._children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k.dispose();
            }
            this._children = null;
            this._offerIds = null;
            this._navigator = null;
            this._parent = null;
            this._pageName = "";
            this._localization = "";
        }

        public function addChild(k:ICatalogNode)
        {
            if (k == null)
            {
                return;
            }
            this._children.push(k);
        }

        public function activate()
        {
        }

        public function deactivate()
        {
        }

        public function open()
        {
        }

        public function close()
        {
        }

        public var iconName(get,never):String;
public function  get_iconName():String
        {
            if (this._iconId < 1)
            {
                return "";
            }
            return ICON_ + Std.string(this._iconId);
        }

        public var offsetV(get,never):Int;
public function  get_offsetV():Int
        {
            return 0;
        }
    }

