package com.sulake.core.utils
;
    import flash.system.Capabilities;

     class PlayerVersionCheck 
    {
        static var _majorVersion:Int = 0;
        static var _minorVersion:Int = 0;
        static var _isParsed:Bool = false;


        public static function isVersionAtLeast(major:Int, minor:Int):Bool
        {
            if (major < PlayerVersionCheck.majorVersion)
            {
                return true;
            }
            if (((major == PlayerVersionCheck.majorVersion) && (minor <= PlayerVersionCheck.minorVersion)))
            {
                return true;
            }
            return false;
        }

        public static var majorVersion(get,never):Int;
public static function  get_majorVersion():Int
        {
            parseVersion();
            return _majorVersion;
        }

        public static var minorVersion(get,never):Int;
public static function  get_minorVersion():Int
        {
            parseVersion();
            return _minorVersion;
        }

        static function parseVersion()
        {
            if (_isParsed)
            {
                return;
            }
            var version:Array<ASAny> = (cast Capabilities.version.split(" "));
            var majMin:Array<ASAny> = version[1].split(",");
            _majorVersion = ((majMin.length >= 1) ? ASCompat.parseInt(majMin[0]) : 0);
            _minorVersion = ((majMin.length >= 2) ? ASCompat.parseInt(majMin[1]) : 0);
            _isParsed = true;
        }

	public function new() {}
    }

