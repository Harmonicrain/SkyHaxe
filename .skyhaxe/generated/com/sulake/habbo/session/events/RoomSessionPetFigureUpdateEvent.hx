package com.sulake.habbo.session.events
;
    import com.sulake.habbo.session.IRoomSession;

     class RoomSessionPetFigureUpdateEvent extends RoomSessionEvent 
    {
        public static inline final PET_FIGURE_UPDATE= "RSPFUE_PET_FIGURE_UPDATE";

        var _petId:Int = 0;
        var _figure:String;

        public function new(k:IRoomSession, id:Int, figure:String, bubbles:Bool=false, cancellable:Bool=false)
        {
            super(PET_FIGURE_UPDATE, k, bubbles, cancellable);
            this._petId = id;
            this._figure = figure;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._petId;
        }

        public var figure(get,never):String;
public function  get_figure():String
        {
            return this._figure;
        }
    }

