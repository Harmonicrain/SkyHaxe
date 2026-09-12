package com.sulake.habbo.freeflowchat.viewer.simulation
;
     class ChatFlowGravity 
    {
        public static inline final _Str_16724= 60;
        public static inline final _Str_8857= 15;
        public static inline final _Str_16944:Float = 40;

        static inline final _Str_24843:Float = 380;
        static inline final _Str_26204:Float = 1;


        public function _Str_20468(k:ChatBubbleSimulationEntity, _arg_2:ChatBubbleSimulationEntity, _arg_3:Float=1, _arg_4:Float=100):Float
        {
            var _local_5= Math.abs((_arg_2._Str_13971 - k._Str_13971));
            if (_local_5 > ChatFlowGravity._Str_24843)
            {
                return 0;
            }
            if (_local_5 < 1)
            {
                return 0;
            }
            var _local_6= ((k._Str_13971 <= _arg_2._Str_13971) ? 1 : -1);
            return _local_6 * Math.min(Math.min(_local_5, (_arg_3 / _local_5)), _arg_4);
        }
public function new(){}
    }

