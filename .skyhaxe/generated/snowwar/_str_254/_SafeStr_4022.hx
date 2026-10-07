package snowwar._str_254
;
	import com.sulake.core.runtime.IDisposable;
    import snowwar._str_231._SafeStr_4028;

     interface _SafeStr_4022 extends IDisposable 
    {
        function distanceTo(_arg_1:_SafeStr_4022):Int;
        function directionTo(_arg_1:_SafeStr_4022):Direction8;
        function getNodeAt(_arg_1:Direction8):_SafeStr_4022;
        function directionIsBlocked(_arg_1:Direction8, _arg_2:_SafeStr_4028):Bool;
        function getPathCost(_arg_1:Direction8, _arg_2:_SafeStr_4028):Int;
                var _SafeStr_18665(get,set):Direction8;
                var _SafeStr_18666(get,set):_SafeStr_4022;
                var _SafeStr_18667(get,set):Int;
                var _SafeStr_18668(get,set):Int;
    }

