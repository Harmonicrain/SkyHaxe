package com.sulake.habbo.inventory
;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import flash.events.IEventDispatcher;
    import com.sulake.habbo.communication.messages.incoming.notifications.UnseenItemsEvent;
    import com.sulake.habbo.inventory._enum.UnseenItemCategoryEnum;
    import com.sulake.habbo.inventory.events.HabboUnseenItemsUpdatedEvent;
    import com.sulake.habbo.communication.messages.outgoing.notifications.ResetUnseenItemIdsComposer;
    import com.sulake.habbo.communication.messages.outgoing.notifications.ResetUnseenItemsComposer;

     class UnseenItemTracker implements IUnseenItemTracker 
    {
        var _communication:IHabboCommunicationManager;
        var _inventory:HabboInventory;
        var _unseenItems:ASDictionary<ASAny,ASAny>;
        var _events:IEventDispatcher;

        public function new(k:IHabboCommunicationManager, _arg_2:IEventDispatcher, _arg_3:HabboInventory)
        {
            this._communication = k;
            this._inventory = _arg_3;
            this._events = _arg_2;
            this._unseenItems = new ASDictionary<ASAny,ASAny>();
            this._communication.addHabboConnectionMessageEvent(new UnseenItemsEvent(this._Str_14461));
        }

        public function dispose()
        {
            this._communication = null;
            this._unseenItems = null;
        }

        public function _Str_8813(k:Int):Bool
        {
            if (this._Str_5621(k) == 0)
            {
                return false;
            }
            this._unseenItems.remove(k);
            this._Str_20981(k);
            this._Str_12141();
            return true;
        }

        public function _Str_18075(k:Int, _arg_2:Array<ASAny>):Bool
        {
            var _local_4 = 0;
            if (this._Str_5621(k) == 0)
            {
                return false;
            }
            var _local_3:Array<ASAny> = this._unseenItems[k];
            if (checkNullIteratee(_arg_2)) for (_tmp_ in _arg_2)
            {
_local_4  = ASCompat.toInt(_tmp_);
                _local_3.splice(_local_3.indexOf(_local_4), 1);
            }
            this._Str_23994(k, _arg_2);
            this._Str_12141();
            return true;
        }

        public function _Str_17159(k:Int):Bool
        {
            if (this._Str_5621(k) == 0)
            {
                this._unseenItems.remove(k);
                this._Str_20981(k);
                this._Str_12141();
                return true;
            }
            return false;
        }

        public function isUnseen(k:Int, _arg_2:Int):Bool
        {
            var _local_3:Array<ASAny> = null;
            if (this._unseenItems[k] != null)
            {
                _local_3 = this._unseenItems[k];
                return _local_3.indexOf(_arg_2) >= 0;
            }
            return false;
        }

        public function _Str_16745(k:Int, _arg_2:Int):Bool
        {
            var _local_3:Array<ASAny> = null;
            var _local_4 = 0;
            if (this._unseenItems[k] != null)
            {
                _local_3 = this._unseenItems[k];
                _local_4 = _local_3.indexOf(_arg_2);
                if (_local_4 >= 0)
                {
                    _local_3.splice(_local_4, 1);
                    this._Str_12141();
                    return true;
                }
            }
            return false;
        }

        public function _Str_11239(k:Int):Array<ASAny>
        {
            if (this._unseenItems[k] != null)
            {
                return this._unseenItems[k];
            }
            return [];
        }

        public function _Str_5621(k:Int):Int
        {
            if (this._unseenItems[k] != null)
            {
                return ((ASCompat.dynamicAs(this._unseenItems[k] , Array) : Array<ASAny>)).length;
            }
            return 0;
        }

        function _Str_14461(k:UnseenItemsEvent)
        {
            var _local_3 = false;
            var _local_4 = 0;
            var _local_5:Array<ASAny> = null;
            var _local_2= k.getParser();
            final _iter_ = _local_2._Str_17858(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = ASCompat.toInt(_tmp_);
                _local_5 = _local_2._Str_24396(_local_4);
                this._Str_18112(_local_4, _local_5);
                if (UnseenItemCategoryEnum._Str_12463.indexOf(_local_4) >= 0)
                {
                    _local_3 = true;
                }
            }
            if (this._inventory.isInitialized)
            {
                this._inventory._Str_6956();
                this._inventory.furniModel._Str_22285();
                this._inventory._Str_4524.updateView();
                this._inventory._Str_8302.updateView();
            }
            this._Str_12141();
        }

        function _Str_12141()
        {
            var _local_3 = 0;
            var _local_4 = 0;
            var k= new HabboUnseenItemsUpdatedEvent();
            var _local_2= UnseenItemCategoryEnum._Str_12463;
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_3  = ASCompat.toInt(_tmp_);
                _local_4 = this._Str_5621(_local_3);
                k._Str_23396(_local_3, _local_4);
                if (UnseenItemCategoryEnum._Str_12463.indexOf(_local_3) >= 0)
                {
                    k._Str_13996 = (k._Str_13996 + _local_4);
                }
            }
            this._events.dispatchEvent(k);
        }

        function _Str_18112(k:Int, _arg_2:Array<ASAny>)
        {
            var _local_3:Array<ASAny> = null;
            var _local_4 = 0;
            var _local_5 = 0;
            if (_arg_2 == null)
            {
                return;
            }
            if (this._unseenItems[k] == null)
            {
                _local_3 = [];
                this._unseenItems[k] = _local_3;
            }
            _local_3 = this._unseenItems[k];
            if (checkNullIteratee(_arg_2)) for (_tmp_ in _arg_2)
            {
_local_4  = ASCompat.toInt(_tmp_);
                _local_5 = _local_3.indexOf(_local_4);
                if (_local_5 != -1)
                {
                }
                else
                {
                    _local_3.push(_local_4);
                }
            }
        }

        function _Str_20981(k:Int)
        {
            this._communication.connection.send(new ResetUnseenItemIdsComposer(k));
        }

        function _Str_23994(k:Int, _arg_2:Array<ASAny>)
        {
            this._communication.connection.send(new ResetUnseenItemsComposer(k, _arg_2));
        }
    }

