package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class NodeData 
    {
        var _visible:Bool = false;
        var _icon:Int = 0;
        var _pageId:Int = 0;
        var _pageName:String;
        var _localization:String;
        var _children:Vector<NodeData>;
        var _offerIds:Vector<Int>;

        public function new(k:IMessageDataWrapper)
        {
            this._visible = k.readBoolean();
            this._icon = k.readInteger();
            this._pageId = k.readInteger();
            this._pageName = k.readString();
            this._localization = k.readString();
            this._offerIds = new Vector<Int>(0);
			
			var _local_2= 0;
			var _local_3= k.readInteger();
            _local_2 = 0;
            while (_local_2 < _local_3)
            {
                this._offerIds.push(k.readInteger());
                _local_2++;
            }
            this._children = new Vector<NodeData>(0);
            var _local_4= k.readInteger();
            _local_2 = 0;
            while (_local_2 < _local_4)
            {
                this._children.push(new NodeData(k));
                _local_2++;
            }
        }

        public var visible(get,never):Bool;
public function  get_visible():Bool
        {
            return this._visible;
        }

        public var icon(get,never):Int;
public function  get_icon():Int
        {
            return this._icon;
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

        public var localization(get,never):String;
public function  get_localization():String
        {
            return this._localization;
        }

        public var children(get,never):Vector<NodeData>;
public function  get_children():Vector<NodeData>
        {
            return this._children;
        }

        public var pageOffers(get,never):Vector<Int>;
public function  get_pageOffers():Vector<Int>
        {
            return this._offerIds;
        }
    }

