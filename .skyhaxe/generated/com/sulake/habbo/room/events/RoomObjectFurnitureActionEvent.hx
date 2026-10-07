package com.sulake.habbo.room.events
;
	import com.sulake.room.events.*;
	import com.sulake.room.object.*;

     class RoomObjectFurnitureActionEvent extends RoomObjectEvent 
    {
        public static inline final DICE_OFF= "ROFCAE_DICE_OFF";
        public static inline final DICE_ACTIVATE= "ROFCAE_DICE_ACTIVATE";
        public static inline final USE_HABBOWHEEL= "ROFCAE_USE_HABBOWHEEL";
        public static inline final STICKIE= "ROFCAE_STICKIE";
        public static inline final ENTER_ONEWAYDOOR= "ROFCAE_ENTER_ONEWAYDOOR";
        public static inline final SOUND_MACHINE_INIT= "ROFCAE_SOUND_MACHINE_INIT";
        public static inline final SOUND_MACHINE_START= "ROFCAE_SOUND_MACHINE_START";
        public static inline final SOUND_MACHINE_STOP= "ROFCAE_SOUND_MACHINE_STOP";
        public static inline final SOUND_MACHINE_DISPOSE= "ROFCAE_SOUND_MACHINE_DISPOSE";
        public static inline final JUKEBOX_INIT= "ROFCAE_JUKEBOX_INIT";
        public static inline final JUKEBOX_START= "ROFCAE_JUKEBOX_START";
        public static inline final JUKEBOX_MACHINE_STOP= "ROFCAE_JUKEBOX_MACHINE_STOP";
        public static inline final JUKEBOX_DISPOSE= "ROFCAE_JUKEBOX_DISPOSE";
        public static inline final MOUSE_BUTTON= "ROFCAE_MOUSE_BUTTON";
        public static inline final MOUSE_ARROW= "ROFCAE_MOUSE_ARROW";

        public function new(k:String, _arg_2:IRoomObject, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(k, _arg_2, _arg_3, _arg_4);
        }
    }

