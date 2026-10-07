package com.sulake.habbo.sound.events
;
    import flash.events.Event;

     class SongDiskInventoryReceivedEvent extends Event 
    {
        public static inline final SDIR_SONG_DISK_INVENTORY_RECEIVENT_EVENT= "SDIR_SONG_DISK_INVENTORY_RECEIVENT_EVENT";

        public function new(k:String, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            super(k, _arg_2, _arg_3);
        }
    }

