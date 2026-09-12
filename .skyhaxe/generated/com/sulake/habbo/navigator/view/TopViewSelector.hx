package com.sulake.habbo.navigator.view
;
    import com.sulake.habbo.navigator.HabboNewNavigator;
    import com.sulake.core.window.components.ITabButtonWindow;
    import com.sulake.core.window.components.ITabContextWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class TopViewSelector 
    {
        var _navigator:HabboNewNavigator;
        var _template:ITabButtonWindow;
        var _tabContext:ITabContextWindow;

        public function new(k:HabboNewNavigator)
        {
            this._navigator = k;
        }

        public var template(never,set):ITabButtonWindow;
public function  set_template(k:ITabButtonWindow):ITabButtonWindow        {
            return this._template = k;
        }

        public var _Str_23159(never,set):ITabContextWindow;
public function  set__Str_23159(k:ITabContextWindow):ITabContextWindow        {
            return this._tabContext = k;
        }

        public function refresh()
        {
            var _local_2:String = null;
            var _local_3:ITabButtonWindow = null;
            this._Str_17441();
            var k = 0;
            while (k < this._navigator._Str_7014._Str_9965().length)
            {
                _local_2 = this._navigator._Str_7014._Str_9965()[k];
                _local_3 = cast(this._template.clone(), ITabButtonWindow);
                _local_3.caption = (("${navigator.toplevelview." + _local_2) + "}");
                _local_3.id = k;
                _local_3.procedure = this._Str_18312;
                this._tabContext._Str_5377(_local_3);
                k++;
            }
        }

        public function _Str_12925(k:Int)
        {
            this._tabContext.selector.setSelected(this._tabContext.getTabButtonAt(k));
        }

        function _Str_17441()
        {
            var k = 0;
            while ((k : UInt) < this._tabContext.numTabs)
            {
                this._tabContext._Str_5897(this._tabContext.getTabButtonAt(0));
                k++;
            }
        }

        function _Str_18312(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                if (this._navigator._Str_7014._Str_9965().length > _arg_2.id)
                {
                    this._navigator.performSearch(this._navigator._Str_7014._Str_9965()[_arg_2.id], "", this._navigator.view._Str_24940());
                }
            }
        }
    }

