package org.openvideoads.vast.config.groupings
;
    import org.openvideoads.base.Debuggable;

     class SurveyConfig extends Debuggable 
    {
        var _id:String = null;
        var _Str_17492:Bool = true;

        public function new(k:ASObject=null)
        {
            super();
            if (k != null)
            {
                this.initialise(k);
            }
        }

        function initialise(k:ASObject)
        {
            if (k.id != /*undefined*/null)
            {
                this._id = k.id;
            }
            if (k.restore != /*undefined*/null)
            {
                if (Std.is(k.restore , String))
                {
                    this._Str_17492 = ((k.restore.toUpperCase() == "TRUE") ? true : false);
                }
                else
                {
                    this._Str_17492 = k.restore;
                }
            }
        }

        public var id(get,never):String;
public function  get_id():String
        {
            return this._id;
        }

        public function declared():Bool
        {
            return !(this._id == null);
        }

        public var restore(get,never):Bool;
public function  get_restore():Bool
        {
            return this._Str_17492;
        }
    }

