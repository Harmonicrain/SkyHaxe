package com.sulake.habbo.notifications.utils
;
    import com.sulake.habbo.room.IRoomEngine;
    import flash.display.BitmapData;
    import com.sulake.room.utils.Vector3d;

     class PetImageUtility 
    {
        static var _Str_2280:IRoomEngine;

        public function new(k:IRoomEngine)
        {
            _Str_2280 = k;
        }

        public function dispose()
        {
            _Str_2280 = null;
        }

        public function getPetImage(k:Int, _arg_2:Int, _arg_3:String, _arg_4:Int=3, _arg_5:Bool=false, _arg_6:Int=32, _arg_7:String=null):BitmapData
        {
            if (_Str_2280 == null)
            {
                Logger.log(["Pet Image Utility; Pet image creation failed: Room engine is not defined"]);
                return null;
            }
            var _local_8:BitmapData = null;
            if (((k < 0) || (_arg_2 < 0)))
            {
                return _local_8;
            }
            var _local_9:UInt = ASCompat.parseInt(_arg_3, 16);
            var _local_10:UInt = 0;
            var _local_11= _Str_2280.getPetImage(k, _arg_2, ASCompat.toInt(_local_9), new Vector3d((45 * _arg_4)), _arg_6, null, _arg_5, _local_10, null, _arg_7);
            if (_local_11 != null)
            {
                _local_8 = _local_11.data;
            }
            return _local_8;
        }
    }

