package com.sulake.habbo.communication.messages.outgoing.inventory.badges
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class SetActivatedBadgesComposer implements IMessageComposer 
    {
        static inline final _Str_20506= 5;

        var _badgeArr:Array<ASAny>;

        public function new()
        {
            this._badgeArr = new Array<ASAny>();
        }

        public function addActivatedBadge(k:String)
        {
            if (this._badgeArr.length >= SetActivatedBadgesComposer._Str_20506)
            {
                return;
            }
            this._badgeArr.push(k);
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            var k= new Array<ASAny>();
            var _local_2= 1;
            while (_local_2 <= SetActivatedBadgesComposer._Str_20506)
            {
                if (_local_2 <= this._badgeArr.length)
                {
                    k.push(_local_2);
                    k.push(this._badgeArr[(_local_2 - 1)]);
                }
                else
                {
                    k.push(_local_2);
                    k.push("");
                }
                _local_2++;
            }
            return k;
        }
    }

