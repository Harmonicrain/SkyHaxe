package com.sulake.room.object.visualization
;
    import com.sulake.room.object.visualization.utils.IGraphicAssetCollection;

     interface IRoomObjectGraphicVisualization extends IRoomObjectVisualization 
    {
                var assetCollection(get,set):IGraphicAssetCollection;
        function setExternalBaseUrls(_arg_1:String, _arg_2:String, _arg_3:Bool):Void;
    }

