package com.sulake.habbo.groups.events
;
    import flash.events.Event;

     class HabboGroupsEditorData extends Event 
    {
        public static inline final HGE_EDIT_INFO= "HGE_EDIT_INFO";

        public function new(k:Bool=false, _arg_2:Bool=false)
        {
            super(HGE_EDIT_INFO, k, _arg_2);
        }
    }

