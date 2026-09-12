package com.sulake.bootstrap
;
    import com.sulake.habbo.moderation.ModerationManager;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;

     class ModerationManagerBootstrap extends ModerationManager 
    {
        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            super(k, _arg_2, _arg_3);
        }
    }

