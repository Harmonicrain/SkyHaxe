package com.sulake.habbo.avatar.structure
;
    import com.sulake.habbo.avatar.structure.figure.Palette;
    import com.sulake.habbo.avatar.structure.figure.SetType;
    import com.sulake.habbo.avatar.structure.figure.IFigurePartSet;
    import com.sulake.habbo.avatar.structure.figure.ISetType;
    import com.sulake.habbo.avatar.structure.figure.IPalette;
    import com.sulake.habbo.avatar.structure.figure.*;

     class FigureSetData implements IFigureSetData implements  IStructureData 
    {
        var _palettes:ASDictionary<ASAny,ASAny>;
        var _setTypes:ASDictionary<ASAny,ASAny>;

        public function new()
        {
            this._palettes = new ASDictionary<ASAny,ASAny>();
            this._setTypes = new ASDictionary<ASAny,ASAny>();
        }

        public function dispose()
        {
        }

        public function parse(k:com.sulake.core.utils.xml.XML):Bool
        {
            var _local_2:com.sulake.core.utils.xml.XML = null;
            var _local_3:com.sulake.core.utils.xml.XML = null;
            if (k == null)
            {
                return false;
            }
            final _iter_ = k.child("colors").child("palette"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                this._palettes[_local_2.attribute("id").toString()] = new Palette(_local_2);
            }
            final _iter_ = k.child("sets").child("settype"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                this._setTypes[_local_3.attribute("type").toString()] = new SetType(_local_3);
            }
            return true;
        }

        public function _Str_1133(k:com.sulake.core.utils.xml.XML)
        {
            var _local_2:com.sulake.core.utils.xml.XML = null;
            var _local_3:SetType = null;
            final _iter_ = k.child("sets").child("settype"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_3 = this._setTypes[_local_2.attribute("type").toString()];
                if (_local_3 != null)
                {
                    _local_3.cleanUp(_local_2);
                }
                else
                {
                    this._setTypes[_local_2.attribute("type").toString()] = new SetType(_local_2);
                }
            }
            this._Str_1017(k);
        }

        public function _Str_1017(k:com.sulake.core.utils.xml.XML):Bool
        {
            var _local_2:com.sulake.core.utils.xml.XML = null;
            var _local_3:com.sulake.core.utils.xml.XML = null;
            var _local_4:Palette = null;
            var _local_5:SetType = null;
            if (k == null)
            {
                return false;
            }
            final _iter_ = k.child("colors").child("palette"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_4 = this._palettes[_local_2.attribute("id").toString()];
                if (_local_4 == null)
                {
                    this._palettes[_local_2.attribute("id").toString()] = new Palette(_local_2);
                }
                else
                {
                    _local_4._Str_2015(_local_2);
                }
            }
            final _iter_ = k.child("sets").child("settype"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                _local_5 = this._setTypes[_local_3.attribute("type").toString()];
                if (_local_5 == null)
                {
                    this._setTypes[_local_3.attribute("type").toString()] = new SetType(_local_3);
                }
                else
                {
                    _local_5._Str_2015(_local_3);
                }
            }
            return false;
        }

        public function getMandatorySetTypeIds(k:String, _arg_2:Int):Array<ASAny>
        {
            var _local_4:SetType = null;
            var _local_3= new Array<ASAny>();
            final _iter_ = this._setTypes; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = _tmp_;
                if (((_local_4 != null) && _local_4._Str_895(k, _arg_2)))
                {
                    _local_3.push(_local_4.type);
                }
            }
            return _local_3;
        }

        public function _Str_2264(k:String, _arg_2:String):IFigurePartSet
        {
            var _local_3= ASCompat.dynamicAs(this._setTypes[k] , SetType);
            if (_local_3 != null)
            {
                return _local_3._Str_2264(_arg_2);
            }
            return null;
        }

        public function _Str_740(k:String):ISetType
        {
            return this._setTypes[k];
        }

        public function getPalette(k:Int):IPalette
        {
            return this._palettes[Std.string(k)];
        }

        public function _Str_938(k:Int):IFigurePartSet
        {
            var _local_2:SetType = null;
            var _local_3:IFigurePartSet = null;
            final _iter_ = this._setTypes; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_3 = _local_2._Str_1020(k);
                if (_local_3 != null)
                {
                    return _local_3;
                }
            }
            return null;
        }
    }

