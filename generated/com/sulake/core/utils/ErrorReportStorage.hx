package com.sulake.core.utils
;
     class ErrorReportStorage 
    {
        static var _errorData:Map = new Map();
        static var _debugData:Map = new Map();

        public static function getDebugData():String
        {
            var result= "";
            var count = 0;
            while ((count : UInt) < _debugData.length)
            {
                if (count == 0)
                {
                    result = _debugData.getWithIndex(count);
                }
                else
                {
                    result = ((result + " ** ") + _debugData.getWithIndex(count));
                }
                count++;
            }
            if (result.length > 400)
            {
                result = result.substr((result.length - 400));
            }
            return result;
        }

        public static function addDebugData(key:String, value:String)
        {
            _debugData.remove(key);
            _debugData.add(key, value);
        }

        public static function setParameter(key:String, value:String)
        {
            _errorData.setValue(key, value);
        }

        public static function getParameter(key:String):String
        {
            return _errorData.getValue(key);
        }

        public static function getParameterNames():Array<ASAny>
        {
            return _errorData.getKeys();
        }

	public function new() {}
    }

