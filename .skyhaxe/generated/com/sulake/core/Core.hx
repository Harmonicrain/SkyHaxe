package com.sulake.core
;
    import com.sulake.core.runtime.ICore;
    import com.sulake.core.runtime.CoreComponentContext;
    import com.sulake.core.runtime.ConsoleCoreErrorReporter;
    import flash.display.DisplayObjectContainer;
    import com.sulake.core.runtime.ICoreErrorLogger;
    import flash.external.ExternalInterface;

     final class Core 
    {
        public static inline final CORE_SETUP_FRAME_UPDATE_SIMPLE:UInt = 0;
        public static inline final CORE_SETUP_FRAME_UPDATE_COMPLEX:UInt = 1;
        public static inline final CORE_SETUP_FRAME_UPDATE_PROFILER:UInt = 2;
        public static inline final CORE_SETUP_FRAME_UPDATE_EXPERIMENT:UInt = 4;
        public static inline final CORE_SETUP_FRAME_UPDATE_MASK:UInt = 15;
        public static inline final CORE_SETUP_DEBUG:UInt = 15;
        public static inline final ERROR_CATEGORY_DOWNLOAD_CONFIGURATION= 1;
        public static inline final ERROR_CATEGORY_DOWNLOAD_LIBRARY= 2;
        public static inline final ERROR_CATEGORY_DOWNLOAD_CRITICAL_ASSET= 3;
        public static inline final ERROR_CATEGORY_PREPARE_COMPONENT= 4;
        public static inline final ERROR_CATEGORY_COMPONENT_RESOURCE_LOAD_ERROR= 5;
        public static inline final ERROR_CATEGORY_INTERFACE_AVAILABILITY= 6;
        public static inline final ERROR_CATEGORY_PRODUCT_DATA= 7;
        public static inline final ERROR_CATEGORY_DOWNLOAD_LOCALIZATION= 8;
        public static inline final ERROR_CATEGORY_FINALIZE_PRELOADING= 9;
        public static inline final ERROR_CATEGORY_INITIALIZE_CORE= 10;
        public static inline final ERROR_CATEGORY_DOWNLOAD_FONT= 11;
        public static inline final ERROR_CATEGORY_FURNIDATA_DOWNLOAD= 12;
        public static inline final ERROR_CATEGORY_DOWNLOAD_EXTERNAL_VARIABLES= 20;
        public static inline final ERROR_CATEGORY_DOWNLOAD_EXTERNAL_VARIABLES_OVERRIDE= 21;
        public static inline final ERROR_CATEGORY_COMMMUNICATION_INIT= 29;
        public static inline final ERROR_CATEGORY_CONNECT_TO_PROXY= 30;
        public static inline final ERROR_UNCAUGHT_ERROR= 40;
        public static inline final ERROR_CATEGORY_INTENTIONAL_DEBUG_CRASH= 99;
        static var _instance:ICore;


        public static var version(get,never):String;
public static function  get_version():String
        {
            return "0.0.3";
        }

        public static var instance(get,never):ICore;
public static function  get_instance():ICore
        {
            return _instance;
        }

        public static function instantiate(displayContainer:DisplayObjectContainer, _arg_2:UInt, errorLogger:ICoreErrorLogger=null):ICore
        {
            if (_instance == null)
            {
                _instance = new CoreComponentContext(displayContainer, ((errorLogger != null) ? errorLogger : new ConsoleCoreErrorReporter()), _arg_2);
            }
            return _instance;
        }

        public static function error(k:String, _arg_2:Bool, _arg_3:Int=-1, _arg_4:ASError=null)
        {
            if (_instance != null)
            {
                _instance.error(k, _arg_2, _arg_3, _arg_4);
            }
        }

        public static function warning(k:String)
        {
            if (_instance != null)
            {
                _instance.warning(k);
            }
            if (ExternalInterface.available)
            {
                ExternalInterface.call("FlashExternalInterface.logWarn", [k]);
            }
        }

        public static function debug(k:String)
        {
            if (_instance != null)
            {
                _instance.debug(k);
            }
            if (ExternalInterface.available)
            {
                ExternalInterface.call("FlashExternalInterface.logDebug", [k]);
            }
        }

        public static function crash(k:String, _arg_2:Int, _arg_3:ASError=null)
        {
			Habbo.trackLoginStep(k);
            if (_instance != null)
            {
                _instance.error(k, true, _arg_2, _arg_3);
            }
        }

        public static function purge()
        {
            if (_instance != null)
            {
                _instance.purge();
            }
        }

        public static function dispose()
        {
            if (_instance != null)
            {
                _instance.dispose();
                _instance = null;
            }
        }

	public function new() {}
    }

