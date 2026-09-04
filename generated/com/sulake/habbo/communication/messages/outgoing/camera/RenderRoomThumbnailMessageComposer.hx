package com.sulake.habbo.communication.messages.outgoing.camera
;
     class RenderRoomThumbnailMessageComposer extends RenderRoomMessageComposer 
    {
        public function new(k:Array<ASAny>, _arg_2:String, _arg_3:String, _arg_4:Int, _arg_5:Int)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5);
            compressData();
        }
    }

