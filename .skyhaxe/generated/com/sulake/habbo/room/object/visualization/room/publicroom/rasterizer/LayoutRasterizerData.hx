package com.sulake.habbo.room.object.visualization.room.publicroom.rasterizer
;
     class LayoutRasterizerData
    {
        var _elementList:com.sulake.core.utils.xml.XMLList;
        var _hasAnimations:Bool = false;

        public function new(k:com.sulake.core.utils.xml.XML)
        {
            var _local_2:com.sulake.core.utils.xml.XML = null;
            var _local_3:com.sulake.core.utils.xml.XMLList = null;
            this._elementList = k.child("elements").child("element");
            this._hasAnimations = false;
            final _iter_ = this._elementList; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_3 = _local_2.child("visualization").child("visualizationLayer");
                if (((_local_3.length() > 0) && (_local_3.at(0).attribute("frames").toString().length > 0)))
                {
                    this._hasAnimations = true;
                    break;
                }
            }
        }

        public var elementList(get,never):com.sulake.core.utils.xml.XMLList;
public function  get_elementList():com.sulake.core.utils.xml.XMLList
        {
            return this._elementList;
        }

        public var hasAnimations(get,never):Bool;
public function  get_hasAnimations():Bool
        {
            return this._hasAnimations;
        }

        public function dispose()
        {
            this._elementList = null;
        }
    }

