package com.sulake.core.window.motion
;
    import com.sulake.core.window.IWindow;

     class Dispose extends Motion 
    {
        public function new(k:IWindow)
        {
            super(k);
        }

        public override function tick(k:Int)
        {
            super.tick(k);
            if (((target != null) && (!target.disposed)))
            {
                target.dispose();
                target = null;
            }
        }
    }

