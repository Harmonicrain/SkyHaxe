package com.sulake.habbo.room.events
;
     class RoomObjectSoundMachineEvent extends RoomEngineObjectEvent 
    {
        public static inline final SOUND_MACHINE_INIT= "ROSM_SOUND_MACHINE_INIT";
        public static inline final SOUND_MACHINE_SWITCHED_ON= "ROSM_SOUND_MACHINE_SWITCHED_ON";
        public static inline final SOUND_MACHINE_SWITCHED_OFF= "ROSM_SOUND_MACHINE_SWITCHED_OFF";
        public static inline final SOUND_MACHINE_DISPOSE= "ROSM_SOUND_MACHINE_DISPOSE";
        public static inline final JUKEBOX_INIT= "ROSM_JUKEBOX_INIT";
        public static inline final JUKEBOX_SWITCHED_ON= "ROSM_JUKEBOX_SWITCHED_ON";
        public static inline final JUKEBOX_SWITCHED_OFF= "ROSM_JUKEBOX_SWITCHED_OFF";
        public static inline final JUKEBOX_DISPOSE= "ROSM_JUKEBOX_DISPOSE";

        public function new(k:String, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Bool=false, _arg_6:Bool=false)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
        }
    }

