package com.sulake.habbo.utils
;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.window.IHabboWindowManager;

     class PerkChecker
    {


        public static function isPerkAllowed(k:ISessionDataManager, _arg_2:IHabboWindowManager, _arg_3:String):Bool
        {
            if (k.isPerkAllowed(_arg_3))
            {
                return true;
            }
            var _local_4= k.getPerkErrorMessage(_arg_3);
            _arg_2.simpleAlert("${perkmissing.title}", "${perkmissing.caption}", (("${" + _local_4) + "}"));
            return false;
        }

	public function new() {}
    }

