package com.sulake.habbo.catalog.viewer.widgets.events
;
    import flash.events.Event;
    import com.sulake.habbo.room.IStuffData;

     class SetRoomPreviewerStuffDataEvent extends Event 
    {
        var _stuffData:IStuffData;

        public function new(k:IStuffData, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            super(CatalogWidgetEvent.SET_PREVIEWER_STUFFDATA, _arg_2, _arg_3);
            this._stuffData = k;
        }

        public var stuffData(get,never):IStuffData;
public function  get_stuffData():IStuffData
        {
            return this._stuffData;
        }
    }

