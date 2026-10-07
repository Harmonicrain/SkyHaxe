package com.sulake.core.window.utils
;
    import com.sulake.core.window._enum.WindowState;

     class StateCodeTable 
    {
        public static function fillTables(dict:ASDictionary<ASAny,ASAny>, addTo:ASDictionary<ASAny,ASAny>=null)
        {
var key:String  = null;            dict["default"] = WindowState.DEFAULT;
            dict["active"] = WindowState.ACTIVE;
            dict["focused"] = WindowState.FOCUSED;
            dict["hovering"] = WindowState.HOVERING;
            dict["selected"] = WindowState.SELECTED;
            dict["pressed"] = WindowState.PRESSED;
            dict["disabled"] = WindowState.DISABLED;
            dict["locked"] = WindowState.LOCKED;
            if (addTo != null)
            {
                if (checkNullIteratee(dict)) for (_tmp_ in dict.keys())
                {
key = _tmp_;
                    addTo[dict[key]] = key;
                }
            }
        }

	public function new() {}
    }

