package com.sulake.habbo.ui.widget.chatinput.habbiconselector
;
     class HabbiconSelectorSection
    {
        public var type:String;
        public var key:String;
        public var title:String;
        public var entries:Array<ASAny>;

        public function new(type:String, key:String, title:String, entries:Array<ASAny>)
        {
            this.type = type;
            this.key = key;
            this.title = title;
            this.entries = entries;
        }
    }

