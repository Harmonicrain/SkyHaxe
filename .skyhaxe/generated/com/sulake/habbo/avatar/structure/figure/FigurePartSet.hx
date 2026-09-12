package com.sulake.habbo.avatar.structure.figure
;
     class FigurePartSet implements IFigurePartSet 
    {
        var _type:String;
        var _id:Int = 0;
        var _gender:String;
        var _clubLevel:Int = 0;
        var _isColorable:Bool = false;
        var _isSelectable:Bool = false;
        var _parts:Array<ASAny>;
        var _hiddenLayers:Array<ASAny>;
        var _isPreSelectable:Bool = false;
        var _isSellable:Bool = false;

        public function new(k:com.sulake.core.utils.xml.XML, _arg_2:String)
        {
            var _local_3:com.sulake.core.utils.xml.XML = null;
            var _local_4:com.sulake.core.utils.xml.XML = null;
            var _local_5:FigurePart = null;
            var _local_6 = 0;
            this._type = _arg_2;
            this._id = ASCompat.parseInt(k.attribute("id").toString());
            this._gender = k.attribute("gender").toString();
            this._clubLevel = ASCompat.parseInt(k.attribute("club").toString());
            this._isColorable = ASCompat.toBool(ASCompat.parseInt(k.attribute("colorable").toString()));
            this._isSelectable = ASCompat.toBool(ASCompat.parseInt(k.attribute("selectable").toString()));
            this._isPreSelectable = ASCompat.toBool(ASCompat.parseInt(k.attribute("preselectable").toString()));
            this._isSellable = ASCompat.toBool(ASCompat.parseInt(k.attribute("sellable").toString()));
            this._parts = new Array<ASAny>();
            this._hiddenLayers = new Array<ASAny>();
            final _iter_ = k.child("part"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                _local_5 = new FigurePart(_local_3);
                _local_6 = this.indexOfPartType(_local_5);
                if (_local_6 != -1)
                {
                    this._parts.insert(_local_6, _local_5);
                }
                else
                {
                    this._parts.push(_local_5);
                }
            }
            final _iter_ = k.child("hiddenlayers").child("layer"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = _tmp_;
                this._hiddenLayers.push(_local_4.attribute("parttype").toString());
            }
        }

        public function dispose()
        {
            var k:FigurePart = null;
            final _iter_ = this._parts; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k.dispose();
            }
            this._parts = null;
            this._hiddenLayers = null;
        }

        function indexOfPartType(k:FigurePart):Int
        {
            var _local_3:FigurePart = null;
            var _local_2 = 0;
            while (_local_2 < this._parts.length)
            {
                _local_3 = this._parts[_local_2];
                if (((_local_3.type == k.type) && (_local_3.index < k.index)))
                {
                    return _local_2;
                }
                _local_2++;
            }
            return -1;
        }

        public function getPart(k:String, _arg_2:Int):IFigurePart
        {
            var _local_3:FigurePart = null;
            final _iter_ = this._parts; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                if (((_local_3.type == k) && (_local_3.id == _arg_2)))
                {
                    return _local_3;
                }
            }
            return null;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return this._type;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var gender(get,never):String;
public function  get_gender():String
        {
            return this._gender;
        }

        public var clubLevel(get,never):Int;
public function  get_clubLevel():Int
        {
            return this._clubLevel;
        }

        public var isColorable(get,never):Bool;
public function  get_isColorable():Bool
        {
            return this._isColorable;
        }

        public var isSelectable(get,never):Bool;
public function  get_isSelectable():Bool
        {
            return this._isSelectable;
        }

        public var parts(get,never):Array<ASAny>;
public function  get_parts():Array<ASAny>
        {
            return this._parts;
        }

        public var hiddenLayers(get,never):Array<ASAny>;
public function  get_hiddenLayers():Array<ASAny>
        {
            return this._hiddenLayers;
        }

        public var isPreSelectable(get,never):Bool;
public function  get_isPreSelectable():Bool
        {
            return this._isPreSelectable;
        }

        public var isSellable(get,never):Bool;
public function  get_isSellable():Bool
        {
            return this._isSellable;
        }
    }

