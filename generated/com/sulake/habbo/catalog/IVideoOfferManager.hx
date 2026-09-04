package com.sulake.habbo.catalog
;
    import com.sulake.habbo.catalog._enum.VideoOfferTypeEnum;

     interface IVideoOfferManager 
    {
        var enabled(get,never):Bool;
        function load(_arg_1:IVideoOfferLauncher):Void;
        function launch(_arg_1:VideoOfferTypeEnum):Bool;
    }

