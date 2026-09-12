package com.sulake.bootstrap
;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;

     class HabboWindowManagerComponentBootstrap extends HabboWindowManagerComponent 
    {
        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
			try
			{
				super(k, _arg_2, _arg_3);
			}
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught); 			{
				Habbo.trackLoginStep(e.getStackTrace());
			}
 }        }
    }

