package com.sulake.habbo.room.object.visualization.data
;
     class ColorData 
    {
        public static inline final DEFAULT_COLOR:UInt = 0xFFFFFF;

        var _colors:Array<ASAny>;

        public function new(k:Int)
        {
            this._colors = [];
            var _local_2 = 0;
            while (_local_2 < k)
            {
                this._colors.push(DEFAULT_COLOR);
                _local_2++;
            }
        }

        public function dispose()
        {
            this._colors = null;
        }

        public function setColor(k:UInt, _arg_2:Int)
        {
            if (((_arg_2 < 0) || (_arg_2 >= this._colors.length)))
            {
                return;
            }
            this._colors[_arg_2] = k;
        }

        public function getColor(k:Int):UInt
        {
            if (((k < 0) || (k >= this._colors.length)))
            {
                return DEFAULT_COLOR;
            }
            return ASCompat.toUInt(this._colors[k]);
        }
    }

