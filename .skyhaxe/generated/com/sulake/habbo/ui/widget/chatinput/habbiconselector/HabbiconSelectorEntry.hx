package com.sulake.habbo.ui.widget.chatinput.habbiconselector
;
     class HabbiconSelectorEntry
    {
        public var habbiconId:Int = 0;
        public var name:String;
        public var searchName:String;
        public var color:UInt = 0;
        public var favorite:Bool = false;

        public function new(habbiconId:Int, name:String, color:UInt, favorite:Bool)
        {
            this.habbiconId = habbiconId;
            this.name = name;
            this.searchName = name != null ? name.toLowerCase() : "";
            this.color = color;
            this.favorite = favorite;
        }
    }

