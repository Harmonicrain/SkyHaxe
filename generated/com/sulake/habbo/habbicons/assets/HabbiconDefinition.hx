package com.sulake.habbo.habbicons.assets
;
     class HabbiconDefinition
    {
        public var previewWidth:Int = 0;
        public var previewHeight:Int = 0;
        public var direction:Int = 0;
        public var animated:Bool = false;
        public var loop:Bool = false;
        public var frames:Array<ASAny>;
        public var steps:Array<ASAny>;

        public function new(previewWidth:Int, previewHeight:Int, direction:Int, animated:Bool, loop:Bool, frames:Array<ASAny>, steps:Array<ASAny>)
        {
            this.previewWidth = previewWidth;
            this.previewHeight = previewHeight;
            this.direction = direction;
            this.animated = animated;
            this.loop = loop;
            this.frames = frames;
            this.steps = steps;
        }
    }

