package com.sulake.habbo.avatar.common
;
    import com.sulake.habbo.avatar.structure.figure.IPartColor;
    import com.sulake.habbo.avatar.structure.figure.IFigurePartSet;
    import com.sulake.habbo.inventory.IHabboInventory;

     class CategoryData 
    {
        static inline final MAX_PALETTES= 2;

        var _parts:Array<ASAny>;
        var _palettes:Array<ASAny>;
        var __Str_22359:Int = -1;
        var _paletteIndexes:Array<ASAny>;

        public function new(k:Array<ASAny>, _arg_2:Array<ASAny>)
        {
            this._parts = k;
            this._palettes = _arg_2;
        }

        static function _Str_21219(k:Array<ASAny>, _arg_2:Int):Int
        {
            var _local_4:AvatarEditorGridColorItem = null;
            if (((!(k != null)) || (k.length == 0)))
            {
                return -1;
            }
            var _local_3 = 0;
            while (_local_3 < k.length)
            {
                _local_4 = k[_local_3];
                if (((_local_4.partColor != null) && (_local_4.partColor.clubLevel <= _arg_2)))
                {
                    return _local_4.partColor.id;
                }
                _local_3++;
            }
            return -1;
        }


        public function dispose()
        {
            var k:AvatarEditorGridPartItem = null;
            var _local_2:Array<ASAny> = null;
            var _local_3:AvatarEditorGridColorItem = null;
            if (this._parts != null)
            {
                final _iter_ = this._parts; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    k.dispose();
                }
                this._parts = null;
            }
            if (this._palettes != null)
            {
                final _iter_ = this._palettes ; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    if (_local_2 != null)
                    {
                        if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
                        {
_local_3  = _tmp_;
                            _local_3.dispose();
                        }
                    }
                }
                this._palettes = null;
            }
            this.__Str_22359 = -1;
            this._paletteIndexes = null;
        }

        public function _Str_20245(k:Int)
        {
            var _local_3:AvatarEditorGridPartItem = null;
            if (this._parts == null)
            {
                return;
            }
            var _local_2 = 0;
            while (_local_2 < this._parts.length)
            {
                _local_3 = this._parts[_local_2];
                if (_local_3.id == k)
                {
                    this._Str_8066(_local_2);
                    return;
                }
                _local_2++;
            }
        }

        public function _Str_17669(k:Array<ASAny>)
        {
            var _local_2:AvatarEditorGridColorItem = null;
            var _local_4:Array<ASAny> = null;
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7:AvatarEditorGridColorItem = null;
            if (this._palettes == null)
            {
                return;
            }
            if (k == null)
            {
                return;
            }
            this._paletteIndexes = ASCompat.allocArray(k.length);
            var _local_3 = 0;
            while (_local_3 < this._palettes.length)
            {
                _local_4 = this.getPalette(_local_3);
                if (_local_4 != null)
                {
                    if (k.length > _local_3)
                    {
                        _local_5 = ASCompat.toInt(k[_local_3]);
                    }
                    else
                    {
                        _local_7 = ASCompat.dynamicAs(_local_4[0] , AvatarEditorGridColorItem);
                        if (((_local_7 != null) && (_local_7.partColor != null)))
                        {
                            _local_5 = _local_7.partColor.id;
                        }
                    }
                    _local_6 = 0;
                    while (_local_6 < _local_4.length)
                    {
                        _local_2 = ASCompat.dynamicAs(_local_4[_local_6] , AvatarEditorGridColorItem);
                        if (_local_2.partColor.id == _local_5)
                        {
                            this._paletteIndexes[_local_3] = _local_6;
                            _local_2.isSelected = true;
                        }
                        else
                        {
                            _local_2.isSelected = false;
                        }
                        _local_6++;
                    }
                }
                _local_3++;
            }
            this._Str_19574();
        }

        public function _Str_8066(k:Int):AvatarEditorGridPartItem
        {
            var _local_2:AvatarEditorGridPartItem = null;
            var _local_3:AvatarEditorGridPartItem = null;
            if (this._parts == null)
            {
                return null;
            }
            if (((this.__Str_22359 >= 0) && (this._parts.length > this.__Str_22359)))
            {
                _local_2 = this._parts[this.__Str_22359];
                if (_local_2 != null)
                {
                    _local_2.Selected = false;
                }
            }
            if (this._parts.length > k)
            {
                _local_3 = ASCompat.dynamicAs(this._parts[k] , AvatarEditorGridPartItem);
                if (_local_3 != null)
                {
                    _local_3.Selected = true;
                    this.__Str_22359 = k;
                    return _local_3;
                }
            }
            return null;
        }

        public function _Str_17959(k:Int, _arg_2:Int):AvatarEditorGridColorItem
        {
            var _local_3= this.getPalette(_arg_2);
            if (_local_3 == null)
            {
                return null;
            }
            if (_local_3.length <= k)
            {
                return null;
            }
            this.deselectColorIndex(ASCompat.toInt(this._paletteIndexes[_arg_2]), _arg_2);
            this._paletteIndexes[_arg_2] = k;
            var _local_4= ASCompat.dynamicAs(_local_3[k] , AvatarEditorGridColorItem);
            if (_local_4 == null)
            {
                return null;
            }
            _local_4.isSelected = true;
            this._Str_19574();
            return _local_4;
        }

        public function _Str_24480(k:Int):Int
        {
            return ASCompat.toInt(this._paletteIndexes[k]);
        }

        function deselectColorIndex(k:Int, _arg_2:Int)
        {
            var _local_3= this.getPalette(_arg_2);
            if (_local_3 == null)
            {
                return;
            }
            if (_local_3.length <= k)
            {
                return;
            }
            var _local_4= ASCompat.dynamicAs(_local_3[k] , AvatarEditorGridColorItem);
            if (_local_4 == null)
            {
                return;
            }
            _local_4.isSelected = false;
        }

        public function getSelectedColorIds():Array<ASAny>
        {
            var _local_7:Array<ASAny> = null;
            var _local_8:AvatarEditorGridColorItem = null;
            if (((!(this._paletteIndexes != null)) || (this._paletteIndexes.length == 0)))
            {
                return null;
            }
            if (((!(this._palettes != null)) || (this._palettes.length == 0)))
            {
                return null;
            }
            var k:Array<ASAny> = ASCompat.dynamicAs(this._palettes[0] , Array);
            if (((!(k != null)) || (k.length == 0)))
            {
                return null;
            }
            var _local_2= ASCompat.dynamicAs(k[0] , AvatarEditorGridColorItem);
            if (((!(_local_2 != null)) || (!(_local_2.partColor != null))))
            {
                return null;
            }
            var _local_3= _local_2.partColor.id;
            var _local_4= new Array<ASAny>();
            var _local_5 = 0;
            while (_local_5 < this._paletteIndexes.length)
            {
                _local_7 = this._palettes[_local_5];
                if (!((!(_local_7 != null)) || (_local_7.length <= _local_5)))
                {
                    if (_local_7.length > this._paletteIndexes[_local_5])
                    {
                        _local_8 = ASCompat.dynamicAs(_local_7[ASCompat.toInt(this._paletteIndexes[_local_5])] , AvatarEditorGridColorItem);
                        if (((_local_8 != null) && (_local_8.partColor != null)))
                        {
                            _local_4.push(_local_8.partColor.id);
                        }
                        else
                        {
                            _local_4.push(_local_3);
                        }
                    }
                    else
                    {
                        _local_4.push(_local_3);
                    }
                }
                _local_5++;
            }
            var _local_6= this._Str_6315();
            if (_local_6 == null)
            {
                return null;
            }
            _local_4 = _local_4.slice(0, Std.int(Math.max(_local_6._Str_17445, 1)));
            return _local_4;
        }

        function _Str_16788():Array<ASAny>
        {
            var _local_2:AvatarEditorGridColorItem = null;
            var k= new Array<ASAny>();
            var _local_3 = 0;
            while (_local_3 < this._paletteIndexes.length)
            {
                _local_2 = this.getSelectedColor(_local_3);
                if (_local_2 != null)
                {
                    k.push(_local_2.partColor);
                }
                else
                {
                    k.push(null);
                }
                _local_3++;
            }
            return k;
        }

        public function getSelectedColor(k:Int):AvatarEditorGridColorItem
        {
            var _local_2= this.getPalette(k);
            if (((!(_local_2 != null)) || (_local_2.length <= this._paletteIndexes[k])))
            {
                return null;
            }
            return ASCompat.dynamicAs(_local_2[ASCompat.toInt(this._paletteIndexes[k])] , AvatarEditorGridColorItem);
        }

        public function getCurrentColorId(k:Int):Int
        {
            var _local_2= this.getSelectedColor(k);
            if (((_local_2 != null) && (_local_2.partColor != null)))
            {
                return _local_2.partColor.id;
            }
            return 0;
        }

        public var parts(get,never):Array<ASAny>;
public function  get_parts():Array<ASAny>
        {
            return this._parts;
        }

        public function getPalette(k:Int):Array<ASAny>
        {
            if (this._paletteIndexes == null)
            {
                return null;
            }
            if (this._palettes == null)
            {
                return null;
            }
            if (this._palettes.length <= k)
            {
                return null;
            }
            return ASCompat.dynamicAs(this._palettes[k] , Array);
        }

        public function _Str_6315():AvatarEditorGridPartItem
        {
            return ASCompat.dynamicAs(this._parts[this.__Str_22359] , AvatarEditorGridPartItem);
        }

        function _Str_19574()
        {
            var _local_2:AvatarEditorGridPartItem = null;
            var k= this._Str_16788();
            final _iter_ = this._parts; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2 != null)
                {
                    _local_2.colors = k;
                }
            }
        }

        public function _Str_23352(k:Int):Bool
        {
            var _local_6 = 0;
            var _local_7:IPartColor = null;
            var _local_8:IFigurePartSet = null;
            var _local_2 = false;
            var _local_3= this._Str_16788();
            if (_local_3 != null)
            {
                _local_6 = 0;
                while (_local_6 < _local_3.length)
                {
                    _local_7 = _local_3[_local_6];
                    if (((!(_local_7 == null)) && (_local_7.clubLevel > k)))
                    {
                        _local_2 = true;
                    }
                    _local_6++;
                }
            }
            var _local_4 = false;
            var _local_5= this._Str_6315();
            if (((!(_local_5 == null)) && (_local_5.partSet != null)))
            {
                _local_8 = _local_5.partSet;
                if (((!(_local_8 == null)) && (_local_8.clubLevel > k)))
                {
                    _local_4 = true;
                }
            }
            return _local_2 || _local_4;
        }

        public function _Str_7960(k:IHabboInventory):Bool
        {
            var _local_4:IFigurePartSet = null;
            var _local_2 = false;
            var _local_3= this._Str_6315();
            if (((!(_local_3 == null)) && (_local_3.partSet != null)))
            {
                _local_4 = _local_3.partSet;
                if ((((!(_local_4 == null)) && _local_4.isSellable) && (!k.hasFigureSetIdInInventory(_local_4.id))))
                {
                    _local_2 = true;
                }
            }
            return _local_2;
        }

        public function _Str_15298(k:Int):Bool
        {
            var _local_3:IFigurePartSet = null;
            var _local_4:AvatarEditorGridPartItem = null;
            var _local_2= this._Str_6315();
            if (((_local_2 != null) && (_local_2.partSet != null)))
            {
                _local_3 = _local_2.partSet;
                if (_local_3.clubLevel > k)
                {
                    _local_4 = this._Str_8066(0);
                    if (((!(_local_4 == null)) && (_local_4.partSet == null)))
                    {
                        this._Str_8066(1);
                    }
                    return true;
                }
            }
            return false;
        }

        public function _Str_23810(k:Int):Bool
        {
            var _local_8:IPartColor = null;
            var _local_2= new Array<ASAny>();
            var _local_3= this._Str_16788();
            var _local_4 = false;
            var _local_5= this.getPalette(0);
            var _local_6= _Str_21219(_local_5, k);
            if (_local_6 == -1)
            {
                return false;
            }
            var _local_7 = 0;
            while (_local_7 < _local_3.length)
            {
                _local_8 = _local_3[_local_7];
                if (_local_8 == null)
                {
                    _local_2.push(_local_6);
                    _local_4 = true;
                }
                else
                {
                    if (_local_8.clubLevel > k)
                    {
                        _local_2.push(_local_6);
                        _local_4 = true;
                    }
                    else
                    {
                        _local_2.push(_local_8.id);
                    }
                }
                _local_7++;
            }
            if (_local_4)
            {
                this._Str_17669(_local_2);
            }
            return _local_4;
        }

        public function _Str_8360(k:IHabboInventory):Bool
        {
            var _local_3:IFigurePartSet = null;
            var _local_4:AvatarEditorGridPartItem = null;
            var _local_2= this._Str_6315();
            if (((_local_2 != null) && (_local_2.partSet != null)))
            {
                _local_3 = _local_2.partSet;
                if ((_local_3.isSellable && (!k.hasFigureSetIdInInventory(_local_3.id))))
                {
                    _local_4 = this._Str_8066(0);
                    if (((!(_local_4 == null)) && (_local_4.partSet == null)))
                    {
                        this._Str_8066(1);
                    }
                    return true;
                }
            }
            return false;
        }

        public var _Str_22359(get,never):Int;
public function  get__Str_22359():Int
        {
            return this.__Str_22359;
        }
    }

