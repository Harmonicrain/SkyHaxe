package org.openvideoads.vast.model
;
    import org.openvideoads.util.NetworkResource;

     class Impression extends NetworkResource 
    {
        public function new(k:String, _arg_2:String)
        {
            super(k, _arg_2);
        }

        public function unload()
        {
            super.close();
        }

        override public function toJSObject():ASObject
        {
            var k:ASObject = super.toJSObject();
            k.eventType = "impression";
            return k;
        }
    }

