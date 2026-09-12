package com.sulake.habbo.window.utils.tableview
;
     interface ITableObject
    {
        var identifier(get,never):String;
        function getTableCell(columnId:String):TableCell;
        function isPropertyUpdated(columnId:String, previous:ASObject):Bool;
        function isUpdated(previous:ASObject):Bool;
    }

