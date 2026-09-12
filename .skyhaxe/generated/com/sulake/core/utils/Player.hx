package com.sulake.core.utils
;
    import flash.system.Capabilities;

     class Player 
    {
        static var _majorVersion:Int = 0;
        static var _majorRevision:Int = 0;
        static var _operatingSystem:String;


        public static var majorVersion(get,never):Int;
public static function  get_majorVersion():Int
        {
            return _majorVersion;
        }

        public static var majorRevision(get,never):Int;
public static function  get_majorRevision():Int
        {
            return _majorRevision;
        }

        public static var operatingSystem(get,never):String;
public static function  get_operatingSystem():String
        {
            return _operatingSystem;
        }

        static function init()
        {
            var data:Array<ASAny> = (cast Capabilities.version.split(" "));
            var version:Array<ASAny> = (cast ASCompat.toString(data[1]).split(","));
            _operatingSystem = data[0];
            _majorVersion = ASCompat.parseInt(version[0]);
            _majorRevision = ASCompat.parseInt(version[1]);
        }

	public function new() {}

	static final ___init = {

        {
            init();
        }

	null;
	};
    }

