package com.sulake.habbo.room.object.visualization.furniture
;
    import com.sulake.room.object.visualization.IRoomObjectVisualizationData;
    import com.sulake.core.assets.IAssetLibrary;

     class GameObjectVisualization implements IRoomObjectVisualizationData 
    {
        var _assets:IAssetLibrary;


        public function dispose()
        {
            this._assets = null;
        }

        public function initialize(k:com.sulake.core.utils.xml.XML):Bool
        {
            return true;
        }

        
        public var assets(get,set):IAssetLibrary;
public function  set_assets(k:IAssetLibrary):IAssetLibrary        {
            return this._assets = k;
        }
public function  get_assets():IAssetLibrary
        {
            return this._assets;
        }

	public function new() {}
    }

