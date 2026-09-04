package com.sulake.habbo.avatar.structure.parts
;
     class ActivePartSet 
    {
        var _id:String;
        var _parts:Array<ASAny>;

        public function new(k:com.sulake.core.utils.xml.XML)
        {
            var _local_2:com.sulake.core.utils.xml.XML;
            this._id = k.attribute("id").toString();
            this._parts = new Array<ASAny>();
            for (_tmp_ in k.child("activePart"))
            {
_local_2  = _tmp_;
                this._parts.push(_local_2.attribute("set-type").toString());
            }
        }

        public var parts(get,never):Array<ASAny>;
function  get_parts():Array<ASAny>
        {
            return this._parts;
        }
    }

