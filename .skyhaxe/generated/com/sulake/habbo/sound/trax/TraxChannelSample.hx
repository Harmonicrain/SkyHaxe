package com.sulake.habbo.sound.trax
;

     class TraxChannelSample 
    {
        var _sample:TraxSample = null;
        var _offset:Int = 0;

        public function new(k:TraxSample, _arg_2:Int)
        {
            this._sample = k;
            this._offset = _arg_2;
        }

        public function setSample(k:Vector<Int>, _arg_2:Int, _arg_3:Int)
        {
            this._offset = this._sample.setSample(k, _arg_2, _arg_3, this._offset);
        }

        public function addSample(k:Vector<Int>, _arg_2:Int, _arg_3:Int)
        {
            this._offset = this._sample.addSample(k, _arg_2, _arg_3, this._offset);
        }
    }

