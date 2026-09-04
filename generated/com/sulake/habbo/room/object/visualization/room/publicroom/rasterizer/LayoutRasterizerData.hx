package com.sulake.habbo.room.object.visualization.room.publicroom.rasterizer
;
     class LayoutRasterizerData
    {
        var _elementList:com.sulake.core.utils.xml.XMLList;
        var _hasAnimations:Bool = false;

        public function new(k:com.sulake.core.utils.xml.XML)
        {
            var _local_2:com.sulake.core.utils.xml.XML;
            var _local_3:com.sulake.core.utils.xml.XMLList;
            this._elementList = k.child("elements").child("element");
            this._hasAnimations = false;
            for (_tmp_ in this._elementList)
            {
_local_2  = _tmp_;
                _local_3 = _local_2.child("visualization").child("visualizationLayer");
                if (((_local_3.length() > 0) && (ASCompat.toString(_local_3.at(0).attribute("frames")).length > 0)))
                {
                    this._hasAnimations = true;
                    break;
                }
            }
        }

        public var elementList(get,never):com.sulake.core.utils.xml.XMLList;
function  get_elementList():com.sulake.core.utils.xml.XMLList
        {
            return this._elementList;
        }

        public var hasAnimations(get,never):Bool;
function  get_hasAnimations():Bool
        {
            return this._hasAnimations;
        }

        public function dispose()
        {
            this._elementList = null;
        }
    }

