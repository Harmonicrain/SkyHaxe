package com.sulake.habbo.room.object.visualization.data
;

     class DirectionalOffsetData 
    {
        var _offsetX:ASDictionary<ASAny,ASAny>;
        var _offsetY:ASDictionary<ASAny,ASAny>;

        public function new()
        {
            this._offsetX = new ASDictionary<ASAny,ASAny>();
            this._offsetY = new ASDictionary<ASAny,ASAny>();
        }

        public function getOffsetX(k:Int, _arg_2:Int):Int
        {
            if (this._offsetX[k] == null)
            {
                return _arg_2;
            }
            return ASCompat.toInt(this._offsetX[k]);
        }

        public function getOffsetY(k:Int, _arg_2:Int):Int
        {
            if (this._offsetY[k] == null)
            {
                return _arg_2;
            }
            return ASCompat.toInt(this._offsetY[k]);
        }

        public function setOffset(k:Int, _arg_2:Int, _arg_3:Int)
        {
            this._offsetX[k] = _arg_2;
            this._offsetY[k] = _arg_3;
        }
    }

