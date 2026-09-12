package com.sulake.habbo.navigator.lift
;
    import com.sulake.habbo.navigator.HabboNewNavigator;
    import com.sulake.habbo.communication.messages.incoming.newnavigator.LiftedRoomData;

     class LiftDataContainer 
    {
        static inline final DEFAULT_IMAGE= "${image.library.url}officialrooms_hq/nav_teaser_wl.png";

        var _navigator:HabboNewNavigator;
        var _liftedRooms:Vector<LiftedRoomData>;

        public function new(k:HabboNewNavigator)
        {
            this._liftedRooms = new Vector<LiftedRoomData>(0);
            this._navigator = k;
        }

        public function setLiftedRooms(k:Vector<LiftedRoomData>)
        {
            this._liftedRooms = k;
        }

        public var liftedRooms(get,never):Vector<LiftedRoomData>;
public function  get_liftedRooms():Vector<LiftedRoomData>
        {
            return this._liftedRooms;
        }

        public function getUrlForLiftImageAtIndex(k:Int):String
        {
            if (((k < 0) || (k > (this._liftedRooms.length - 1))))
            {
                return "";
            }
            if (this._liftedRooms[k].image == "")
            {
                return DEFAULT_IMAGE;
            }
            return this._navigator._Str_25225 + this._liftedRooms[k].image;
        }
    }

