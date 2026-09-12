package com.sulake.habbo.window.widgets
;
     interface IProductDisplayInfo
    {
        var productTypeId(get,never):Int;
        var itemTypeId(get,never):String;
        var extraData(get,never):String;
        var petFigureString(get,never):String;
        var botFigureString(get,never):String;
        var figureSetIds(get,never):Vector<Int>;
    }

