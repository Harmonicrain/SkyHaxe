package com.sulake.core.window.graphics.renderer
;
    import com.sulake.core.window.utils.IChildEntityArray;
    import com.sulake.core.window.utils.IChildEntity;
    import com.sulake.core.assets.IAsset;

     interface ISkinTemplate extends IChildEntityArray extends  IChildEntity 
    {
        var asset(get,never):IAsset;
        function dispose():Void;
    }

