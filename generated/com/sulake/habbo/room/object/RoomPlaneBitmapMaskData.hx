package com.sulake.habbo.room.object
;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.utils.IVector3d;

     class RoomPlaneBitmapMaskData 
    {
        public static inline final WINDOW= "window";
        public static inline final HOLE= "hole";

        var _loc:Vector3d = null;
        var _type:String = null;
        var _category:String = null;

        public function new(type:String, loc:IVector3d, category:String)
        {
            this.type = type;
            this.loc = loc;
            this.category = category;
        }

        
        public var loc(get,set):IVector3d;
function  get_loc():IVector3d
        {
            return this._loc;
        }
function  set_loc(k:IVector3d):IVector3d        {
            if (this._loc == null)
            {
                this._loc = new Vector3d();
            }
            this._loc.assign(k);
return k;
        }

        
        public var type(get,set):String;
function  get_type():String
        {
            return this._type;
        }
function  set_type(type:String):String        {
            return this._type = type;
        }

        
        public var category(get,set):String;
function  get_category():String
        {
            return this._category;
        }
function  set_category(category:String):String        {
            return this._category = category;
        }

        public function dispose()
        {
            this._loc = null;
        }
    }

