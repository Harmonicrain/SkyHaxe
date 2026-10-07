package com.sulake.habbo.freeflowchat
;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;

     class Scale9BitmapSprite extends Sprite
    {
        var _source:BitmapData;
        var _grid:Rectangle;
        var _targetWidth:Float = Math.NaN;
        var _targetHeight:Float = Math.NaN;

        public function new(k:Rectangle, _arg_2:BitmapData)
        {
            super();
            this._source = _arg_2;
            this._grid = k.clone();
            this._targetWidth = _arg_2.width;
            this._targetHeight = _arg_2.height;
            this.redraw();
        }

        override public function  get_width():Float
        {
            return this._targetWidth;
        }

        override public function  set_width(k:Float):Float        {
            k = Math.max(0, k);
            if (this._targetWidth == k)
            {
                return k;
            }
            this._targetWidth = k;
            this.redraw();
return k;
        }

        override public function  get_height():Float
        {
            return this._targetHeight;
        }

        override public function  set_height(k:Float):Float        {
            k = Math.max(0, k);
            if (this._targetHeight == k)
            {
                return k;
            }
            this._targetHeight = k;
            this.redraw();
return k;
        }

        function redraw()
        {
            var _local_1= Math.max(0, this._targetWidth);
            var _local_2= Math.max(0, this._targetHeight);
            var _local_3= Math.max(0, this._grid.left);
            var _local_4= Math.max(0, this._source.width - this._grid.right);
            var _local_5= Math.max(0, this._grid.top);
            var _local_6= Math.max(0, this._source.height - this._grid.bottom);
            var _local_7= Math.max(0, this._source.width - (_local_3 + _local_4));
            var _local_8= Math.max(0, this._source.height - (_local_5 + _local_6));
            var _local_9 = Math.NaN;
            var _local_10 = Math.NaN;
            var _local_11 = Math.NaN;
            var _local_12 = Math.NaN;
            var _local_13 = Math.NaN;
            var _local_14 = Math.NaN;
            var _local_15 = Math.NaN;
            var _local_16 = Math.NaN;
            if (_local_1 >= (_local_3 + _local_4))
            {
                _local_9 = _local_3;
                _local_10 = _local_4;
                _local_11 = (_local_1 - _local_3) - _local_4;
            }
            else
            {
                _local_12 = ((_local_3 + _local_4) == 0) ? 0 : (_local_1 / (_local_3 + _local_4));
                _local_9 = (_local_3 * _local_12);
                _local_10 = (_local_4 * _local_12);
                _local_11 = 0;
            }
            if (_local_2 >= (_local_5 + _local_6))
            {
                _local_13 = _local_5;
                _local_14 = _local_6;
                _local_15 = (_local_2 - _local_5) - _local_6;
            }
            else
            {
                _local_16 = ((_local_5 + _local_6) == 0) ? 0 : (_local_2 / (_local_5 + _local_6));
                _local_13 = (_local_5 * _local_16);
                _local_14 = (_local_6 * _local_16);
                _local_15 = 0;
            }
            var _local_17:Array<ASAny> = [0, _local_3, (_local_3 + _local_7), this._source.width];
            var _local_18:Array<ASAny> = [0, _local_5, (_local_5 + _local_8), this._source.height];
            var _local_19:Array<ASAny> = [0, _local_9, (_local_9 + _local_11), _local_1];
            var _local_20:Array<ASAny> = [0, _local_13, (_local_13 + _local_15), _local_2];
            var _local_21 = 0;
            var _local_22 = 0;
            var _local_23 = Math.NaN;
            var _local_24 = Math.NaN;
            var _local_25 = Math.NaN;
            var _local_26 = Math.NaN;
            var _local_27 = Math.NaN;
            var _local_28 = Math.NaN;
            var _local_29:Matrix = null;
            this.graphics.clear();
            while (_local_21 < 3)
            {
                _local_22 = 0;
                while (_local_22 < 3)
                {
                    _local_23 = ASCompat.toNumber(ASCompat.toNumber(_local_17[_local_21 + 1]) - ASCompat.toNumber(_local_17[_local_21]));
                    _local_24 = ASCompat.toNumber(ASCompat.toNumber(_local_18[_local_22 + 1]) - ASCompat.toNumber(_local_18[_local_22]));
                    _local_25 = ASCompat.toNumber(ASCompat.toNumber(_local_19[_local_21 + 1]) - ASCompat.toNumber(_local_19[_local_21]));
                    _local_26 = ASCompat.toNumber(ASCompat.toNumber(_local_20[_local_22 + 1]) - ASCompat.toNumber(_local_20[_local_22]));
                    if (((((_local_23 > 0) && (_local_24 > 0)) && (_local_25 > 0)) && (_local_26 > 0)))
                    {
                        _local_27 = (_local_25 / _local_23);
                        _local_28 = (_local_26 / _local_24);
                        _local_29 = new Matrix();
                        _local_29.scale(_local_27, _local_28);
                        _local_29.translate(ASCompat.toNumber(ASCompat.toNumber(_local_19[_local_21]) - ASCompat.toNumber(ASCompat.toNumber(_local_17[_local_21]) * _local_27)), ASCompat.toNumber(ASCompat.toNumber(_local_20[_local_22]) - ASCompat.toNumber(ASCompat.toNumber(_local_18[_local_22]) * _local_28)));
                        this.graphics.beginBitmapFill(this._source, _local_29, false, true);
                        this.graphics.drawRect(ASCompat.toNumber(_local_19[_local_21]), ASCompat.toNumber(_local_20[_local_22]), _local_25, _local_26);
                        this.graphics.endFill();
                    }
                    _local_22++;
                }
                _local_21++;
            }
        }
    }

