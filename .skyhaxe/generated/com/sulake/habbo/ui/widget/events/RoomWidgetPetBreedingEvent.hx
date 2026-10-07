package com.sulake.habbo.ui.widget.events
;
     class RoomWidgetPetBreedingEvent extends RoomWidgetUpdateEvent
    {
        public static inline final TYPE_START= 0;
        public static inline final TYPE_CANCEL= 1;
        public static inline final TYPE_ACCEPT= 2;
        public static inline final TYPE_REQUEST= 3;
        public static inline final PET_BREEDING= "RWPPBE_PET_BREEDING_";

        var _state:Int = 0;
        var _ownPetId:Int = 0;
        var _otherPetId:Int = 0;

        public function new(k:Bool=false, _arg_2:Bool=false)
        {
            super(PET_BREEDING, k, _arg_2);
        }

        
        public var state(get,set):Int;
public function  get_state():Int
        {
            return this._state;
        }
public function  set_state(k:Int):Int        {
            return this._state = k;
        }

        
        public var ownPetId(get,set):Int;
public function  get_ownPetId():Int
        {
            return this._ownPetId;
        }
public function  set_ownPetId(k:Int):Int        {
            return this._ownPetId = k;
        }

        
        public var otherPetId(get,set):Int;
public function  get_otherPetId():Int
        {
            return this._otherPetId;
        }
public function  set_otherPetId(k:Int):Int        {
            return this._otherPetId = k;
        }
    }

