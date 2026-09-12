package com.sulake.core.window.utils
;
     class ChildEntityArray extends ChildEntityArrayReader implements IChildEntityArray 
    {
        public function removeChild(k:IChildEntity):IChildEntity
        {
            var _local_2= messageArray.indexOf(k);
            if (_local_2 < 0)
            {
                return null;
            }
            messageArray.splice(_local_2, 1);
            return k;
        }

        public function addChild(k:IChildEntity):IChildEntity
        {
            messageArray.push(k);
            return k;
        }

        public function addChildAt(k:IChildEntity, _arg_2:Int):IChildEntity
        {
            messageArray.insertAt(_arg_2, k);
            return k;
        }

        public function removeChildAt(k:Int):IChildEntity
        {
            var _local_2= messageArray[k];
            if (_local_2 != null)
            {
                messageArray.splice(k, 1);
                return _local_2;
            }
            return null;
        }

        public function setChildIndex(k:IChildEntity, _arg_2:Int)
        {
            var _local_3= messageArray.indexOf(k);
            if (((_local_3 > -1) && (!(_arg_2 == _local_3))))
            {
                messageArray.splice(_local_3, 1);
                messageArray.insertAt(_arg_2, k);
            }
        }

        public function swapChildren(k:IChildEntity, _arg_2:IChildEntity)
        {
            var _local_3 = 0;
            var _local_4 = 0;
            var _local_5:IChildEntity = null;
            var _local_6 = 0;
            if ((((!(k == null)) && (!(_arg_2 == null))) && (!(k == _arg_2))))
            {
                _local_3 = messageArray.indexOf(k);
                if (_local_3 < 0)
                {
                    return;
                }
                _local_4 = messageArray.indexOf(_arg_2);
                if (_local_4 < 0)
                {
                    return;
                }
                if (_local_4 < _local_3)
                {
                    _local_5 = k;
                    k = _arg_2;
                    _arg_2 = _local_5;
                    _local_6 = _local_3;
                    _local_3 = _local_4;
                    _local_4 = _local_6;
                }
                messageArray.splice(_local_4, 1);
                messageArray.splice(_local_3, 1);
                messageArray.insertAt(_local_3, _arg_2);
                messageArray.insertAt(_local_4, k);
            }
        }

        public function swapChildrenAt(k:Int, _arg_2:Int)
        {
            this.swapChildren(messageArray[k], messageArray[_arg_2]);
        }

	public function new() { super(); }
    }

