package com.sulake.core.window.utils
;

     class ChildEntityArrayReader implements IChildEntityArrayReader 
    {
        var messageArray:Vector<IChildEntity>;

        public function new()
        {
            this.messageArray = new Vector<IChildEntity>();
        }

        public var numChildren(get,never):Int;
public function  get_numChildren():Int
        {
            return this.messageArray.length;
        }

        public function getChildAt(k:Int):IChildEntity
        {
            return this.messageArray[k];
        }

        public function getChildByID(k:Int):IChildEntity
        {
            var _local_2:IChildEntity = null;
            final _iter_ = this.messageArray; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.id == (k : UInt))
                {
                    return _local_2;
                }
            }
            return null;
        }

        public function getChildByName(k:String):IChildEntity
        {
            var _local_2:IChildEntity = null;
            final _iter_ = this.messageArray; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.name == k)
                {
                    return _local_2;
                }
            }
            return null;
        }

        public function getChildIndex(k:IChildEntity):Int
        {
            return this.messageArray.indexOf(k);
        }

        public function groupChildrenWithID(k:UInt, _arg_2:Array<ASAny>):UInt
        {
            var _local_3:IChildEntity = null;
            var _local_4:UInt = 0;
            final _iter_ = this.messageArray; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                if (_local_3.id == k)
                {
                    _arg_2.push(_local_3);
                    _local_4++;
                }
            }
            return _local_4;
        }
    }

