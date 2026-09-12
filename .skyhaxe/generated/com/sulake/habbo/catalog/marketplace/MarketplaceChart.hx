package com.sulake.habbo.catalog.marketplace
;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.display.Shape;
    import flash.display.BitmapData;
    import flash.geom.Matrix;

     class MarketplaceChart 
    {
        var _x:Array<ASAny>;
        var _y:Array<ASAny>;
        var _chartWidth:Int = 0;
        var _chartHeight:Int = 0;
        var _xMin:Int = -30;
        var _yMax:Int = 0;

        public function new(k:Array<ASAny>, _arg_2:Array<ASAny>)
        {
            this._x = k.slice(0);
            this._y = _arg_2.slice(0);
        }

        public function draw(k:Int, _arg_2:Int):BitmapData
        {
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6:TextField = null;
            var _local_7:TextFormat = null;
            var _local_8 = 0;
            var _local_9:Shape = null;
            var _local_10 = 0;
            var _local_3= new BitmapData(k, _arg_2);
            if (!this.available)
            {
                return _local_3;
            }
            this._yMax = 0;
            final _iter_ = this._y; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = ASCompat.toInt(_tmp_);
                if (_local_4 > this._yMax)
                {
                    this._yMax = _local_4;
                }
            }
            _local_5 = Std.int(Math.pow(10, (Std.string(this._yMax).length - 1)));
            this._yMax = Std.int(Math.fceil((this._yMax / _local_5)) * _local_5);
            _local_6 = new TextField();
            _local_7 = new TextFormat();
            _local_6.embedFonts = true;
            _local_7.font = "Volter";
            _local_7.size = 9;
            _local_6.defaultTextFormat = _local_7;
            _local_6.text = Std.string(this._yMax);
            _local_3.draw(_local_6);
            this._chartWidth = Std.int((k - _local_6.textWidth) - 2);
            this._chartHeight = Std.int(_arg_2 - _local_6.textHeight);
            _local_8 = Std.int(_local_6.textWidth);
            _local_6.text = "0";
            _local_3.draw(_local_6, new Matrix(1, 0, 0, 1, ((_local_8 - _local_6.textWidth) + 1), ((_arg_2 - _local_6.textHeight) - 1)));
            _local_9 = new Shape();
            _local_9.graphics.lineStyle(1, 0xCCCCCC);
            _local_9.graphics.moveTo(0, 0);
            _local_9.graphics.lineTo(0, this._chartHeight);
            _local_10 = 0;
            while (_local_10 <= 5)
            {
                _local_4 = Std.int(((this._chartHeight - 1) / 5) * _local_10);
                _local_9.graphics.moveTo(0, _local_4);
                _local_9.graphics.lineTo((this._chartWidth - 1), _local_4);
                _local_10++;
            }
            _local_9.graphics.lineStyle(2, 0xFF);
            _local_9.graphics.moveTo(this.getX(0), this.getY(0));
            _local_10 = 1;
            while (_local_10 < this._x.length)
            {
                _local_9.graphics.lineTo(this.getX(_local_10), this.getY(_local_10));
                _local_10++;
            }
            _local_3.draw(_local_9, new Matrix(1, 0, 0, 1, (k - this._chartWidth), ((_arg_2 - this._chartHeight) / 2)));
            return _local_3;
        }

        function getX(k:Int):Float
        {
            return ASCompat.toNumber(this._chartWidth + ((this._chartWidth / -this._xMin) * ASCompat.toNumber(this._x[k])));
        }

        function getY(k:Int):Float
        {
            return ASCompat.toNumber(this._chartHeight - ASCompat.toNumber((this._chartHeight / this._yMax) * ASCompat.toNumber(this._y[k])));
        }

        public var available(get,never):Bool;
public function  get_available():Bool
        {
            return ((this._x != null) && (this._y != null)) && (this._x.length > 1);
        }
    }

