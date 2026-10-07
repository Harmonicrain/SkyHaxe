package com.sulake.room.renderer
;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.runtime.IContext;

     class RoomRendererFactory extends Component implements IRoomRendererFactory 
    {
        public function new(k:IContext, _arg_2:UInt=0)
        {
            super(k, _arg_2);
        }

        public function createRenderer():IRoomRenderer
        {
            var k= new RoomRenderer(this);
            return k;
        }
    }

