package com.sulake.core.window.utils.tablet
;
    import com.sulake.core.window.utils.MouseEventProcessor;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window.utils.EventProcessorState;
    import com.sulake.core.window.utils.IEventQueue;

     class TabletEventProcessor extends MouseEventProcessor 
    {
        var _lastEventType:String = "";


        override public function process(k:EventProcessorState, _arg_2:IEventQueue)
        {
            if (_arg_2.length == 0)
            {
                return;
            }
            _desktopWindow = k.desktop;
            _Str_3275 = Std.downcast(k.hoverWindow , WindowController);
            _Str_3558 = Std.downcast(k.lastClickTarget , WindowController);
            _renderer = k.renderer;
            _Str_8811 = k.eventTrackers;
            _arg_2.begin();
            _arg_2.end();
            k.desktop = _desktopWindow;
            k.hoverWindow = _Str_3275;
            k.lastClickTarget = _Str_3558;
            k.renderer = _renderer;
            k.eventTrackers = _Str_8811;
        }

	public function new() { super(); }
    }

