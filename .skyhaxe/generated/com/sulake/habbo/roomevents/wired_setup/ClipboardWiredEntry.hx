package com.sulake.habbo.roomevents.wired_setup
;
     class ClipboardWiredEntry
    {
        public var intParams:Array<ASAny>;
        public var stringParam:String;
        public var variableIds:Array<ASAny>;
        public var stuffIds:Array<ASAny>;
        public var stuffIds2:Array<ASAny>;
        public var furniSourceTypes:Array<ASAny>;
        public var userSourceTypes:Array<ASAny>;
        public var delayInPulses:Int = 0;
        public var quantifierCode:Int = 0;
        public var isFilter:Bool = false;
        public var isInvert:Bool = false;

        public function new(intParams:Array<ASAny>, stringParam:String,
            variableIds:Array<ASAny>, stuffIds:Array<ASAny>, stuffIds2:Array<ASAny>,
            furniSourceTypes:Array<ASAny>, userSourceTypes:Array<ASAny>)
        {
            this.intParams = intParams != null ? intParams.copy() : [];
            this.stringParam = stringParam != null ? stringParam : "";
            this.variableIds = variableIds != null ? variableIds.copy() : [];
            this.stuffIds = stuffIds != null ? stuffIds.copy() : [];
            this.stuffIds2 = stuffIds2 != null ? stuffIds2.copy() : [];
            this.furniSourceTypes = furniSourceTypes != null ? furniSourceTypes.copy() : [];
            this.userSourceTypes = userSourceTypes != null ? userSourceTypes.copy() : [];
        }
    }

