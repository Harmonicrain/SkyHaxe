package com.sulake.habbo.room.object.visualization.data
;
     class AnimationFrameDirectionalData extends AnimationFrameData 
    {
        var _directionalOffsets:DirectionalOffsetData;

        public function new(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Int, _arg_6:DirectionalOffsetData, _arg_7:Int)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_7);
            this._directionalOffsets = _arg_6;
        }

        override public function hasDirectionalOffsets():Bool
        {
            return !(this._directionalOffsets == null);
        }

        override public function getX(k:Int):Int
        {
            if (this._directionalOffsets != null)
            {
                return this._directionalOffsets.getOffsetX(k, super.getX(k));
            }
            return super.getX(k);
        }

        override public function getY(k:Int):Int
        {
            if (this._directionalOffsets != null)
            {
                return this._directionalOffsets.getOffsetY(k, super.getY(k));
            }
            return super.getY(k);
        }
    }

