package com.sulake.core.window.components
;
    import com.sulake.core.window.IWindowContainer;

     interface IHeaderWindow extends IWindowContainer 
    {
        var title(get,never):ILabelWindow;
        var controls(get,never):IItemListWindow;
    }

