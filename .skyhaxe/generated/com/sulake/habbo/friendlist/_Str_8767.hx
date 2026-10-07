package com.sulake.habbo.friendlist
;
     class _Str_8767 
    {


        public function _Str_22500():UInt
        {
            return 0xFF3CB8FF;
        }

        public function _Str_25579(k:Bool):UInt
        {
            return k ? 0xFFFFFFFF : 0xFF000000;
        }

        public function _Str_26157(k:Bool):UInt
        {
            return k ? 0xFFEEEEEE : 0xFFB2B09F;
        }

        public function _Str_9273(k:Int, _arg_2:Bool):UInt
        {
            if (k == _Str_2777._Str_4113)
            {
                return _arg_2 ? 0xFFFFFFFF : 0xFFEEEEEE;
            }
            if (k == _Str_2777._Str_3798)
            {
                return _arg_2 ? 0xFFFFFFFF : 0xFFEEEEEE;
            }
            return _arg_2 ? 0xFFB6B6B6 : 0xFF9F9F9F;
        }

        public function _Str_24837(k:Bool, _arg_2:Int):UInt
        {
            if (k)
            {
                return 0xFFFFFFFF;
            }
            if (_arg_2 == _Str_2777._Str_4113)
            {
                return 0xFF000000;
            }
            if (_arg_2 == _Str_2777._Str_3798)
            {
                return 0xFFF6F6F6;
            }
            return 0xFFEFEFEF;
        }

        public function _Str_19241(k:Int):UInt
        {
            if (k == _Str_2777._Str_4113)
            {
                return 0xFFFFFFFF;
            }
            if (k == _Str_2777._Str_3798)
            {
                return 0xFFFFFFFF;
            }
            return 0xFFB6B6B6;
        }
public function new(){}
    }

