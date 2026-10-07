package com.sulake.habbo.ui.widget.events
;
    import flash.display.BitmapData;

     class RoomWidgetPetFigureUpdateEvent extends RoomWidgetUpdateEvent 
    {
        public static inline final PET_FIGURE_UPDATE= "RWPIUE_PET_FIGURE_UPDATE";

        var _petId:Int = 0;
        var _image:BitmapData;

        public function new(k:Int, _arg_2:BitmapData, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(PET_FIGURE_UPDATE, _arg_3, _arg_4);
            this._petId = k;
            this._image = _arg_2;
        }

        public var petId(get,never):Int;
public function  get_petId():Int
        {
            return this._petId;
        }

        public var image(get,never):BitmapData;
public function  get_image():BitmapData
        {
            return this._image;
        }
    }

