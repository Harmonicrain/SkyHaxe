package com.sulake.habbo.catalog.recycler
;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.communication.messages.incoming.recycler.RecyclerStatusEvent;
    import com.sulake.habbo.communication.messages.incoming.recycler.RecyclerFinishedEvent;

     class RecyclerLogic implements IRecycler 
    {
        static inline final _Str_13868= 0;
        static inline final _Str_9243= 1;
        static inline final _Str_13576= 2;

        var _Str_6624:Int = 0;
        var _Str_16884:Int = 0;
        var _Str_3602:Array<ASAny>;
        var _habboCatalog:HabboCatalog;
        var _windowManager:IHabboWindowManager;
        var _view:_Str_7232;
        var _Str_3154:Array<ASAny>;
        var _Str_7638:Int = 0;

        public function new(k:HabboCatalog, _arg_2:IHabboWindowManager)
        {
            this._Str_3602 = new Array<ASAny>();
            this._habboCatalog = k;
            this._windowManager = _arg_2;
            this._Str_7638 = k.getInteger("recycler.number_of_slots", 5);
        }

        var _Str_14201(get,never):Bool;
function  get__Str_14201():Bool
        {
            return !(this._Str_6624 == _Str_13868);
        }

        var _Str_12921(get,never):Bool;
function  get__Str_12921():Bool
        {
            return !(this._Str_16884 == RecyclerStatusEvent._Str_14635);
        }

        var ready(get,never):Bool;
function  get_ready():Bool
        {
            return this.active && (this._Str_6624 == _Str_9243);
        }

        public var active(get,never):Bool;
public function  get_active():Bool
        {
            return this._Str_14201 && this._Str_12921;
        }

        public var numberOfSlots(get,never):Int;
public function  get_numberOfSlots():Int
        {
            return this._Str_7638;
        }

        public function dispose()
        {
            this._Str_3602 = null;
            this._habboCatalog = null;
            this._windowManager = null;
        }

        public function init(k:_Str_7232=null)
        {
            this._Str_6624 = _Str_13576;
            this._Str_3602 = ASCompat.allocArray(this._Str_7638);
            if (k == null)
            {
                return;
            }
            this._view = k;
            this._habboCatalog.getRecyclerStatus();
        }

        public function activate()
        {
            if (this._Str_12921)
            {
                this._Str_6624 = _Str_9243;
            }
        }

        public function cancel()
        {
            this._habboCatalog.setupInventoryForRecycler(false);
            var k = 0;
            while (k < this._Str_7638)
            {
                this.releaseSlot(k);
                k++;
            }
            this._Str_6624 = _Str_13868;
        }

        public function empty()
        {
            var k = 0;
            while (k < this._Str_7638)
            {
                this.releaseSlot(k);
                k++;
            }
            this._Str_15040();
            this._Str_8448();
        }

        public function _Str_25018(k:Int, _arg_2:Int)
        {
            this._Str_16884 = k;
            if (!this._Str_12921)
            {
                return;
            }
            switch (this._Str_16884)
            {
                case RecyclerStatusEvent._Str_16635:
                    this._Str_6624 = _Str_9243;
                    if (((this._view == null) || this._view.disposed))
                    {
                        return;
                    }
                    this._view._Str_19869();
                    this._habboCatalog.setupInventoryForRecycler(true);
                    this._Str_21753();
                    this._Str_15040();
                    this._Str_8448();
                    return;
                case RecyclerStatusEvent._Str_14635:
                    if (((this._view == null) || this._view.disposed))
                    {
                        return;
                    }
                    this._view._Str_17679();
                    this._habboCatalog.setupInventoryForRecycler(false);
                    return;
                case RecyclerStatusEvent._Str_16908:
                    if (((this._view == null) || this._view.disposed))
                    {
                        return;
                    }
                    this._view._Str_19627(_arg_2);
                    this._habboCatalog.setupInventoryForRecycler(false);
                    return;
            }
        }

        public function _Str_22958(status:Int, prizeId:Int)
        {
            if (!this._Str_14201)
            {
                return;
            }
            this._Str_6624 = _Str_9243;
            if (!this._Str_12921)
            {
                return;
            }
            switch (status)
            {
                case RecyclerFinishedEvent._Str_15052:
                    if (this._view != null)
                    {
                        this._view._Str_20131();
                    }
                    
                case RecyclerFinishedEvent._Str_18717:
                    Logger.log(["* Recycler finished with FAILURE"]);
                    this._windowManager.alert("${generic.alert.title}", "${recycler.info.closed}", 0, function (k:com.sulake.habbo.window.utils.IAlertDialog, _arg_2:com.sulake.core.window.events.WindowEvent)
                    {
                        k.dispose();
                    });
                    if (this._view != null)
                    {
                        this._view._Str_17679();
                    }
                    
            }
            this._habboCatalog.setupInventoryForRecycler(false);
        }

        public function _Str_18924(k:Int):_Str_3718
        {
            if (this._Str_3602 == null)
            {
                return null;
            }
            if (k >= this._Str_3602.length)
            {
                return null;
            }
            return this._Str_3602[k];
        }

        public function placeObjectAtSlot(slotId:Int, id:Int, category:Int, typeId:Int, xxxExtra:String)
        {
            var oldObjectData:_Str_3718 = null;
            var newSlotId = 0;
            if (!this.ready)
            {
                return;
            }
            if (this._Str_3602.length > 0)
            {
                oldObjectData = this._Str_3602[0];
                newSlotId = 0;
                while (((!(oldObjectData == null)) && (newSlotId < this._Str_7638)))
                {
                    oldObjectData = this._Str_3602[newSlotId];
                    if (oldObjectData != null)
                    {
                        newSlotId = (newSlotId + 1);
                    }
                }
                if (oldObjectData == null)
                {
                    slotId = newSlotId;
                }
                else
                {
                    return;
                }
            }
            var itemId= this._habboCatalog.requestInventoryFurniToRecycler();
            if (itemId == 0)
            {
                this._windowManager.alert("${generic.alert.title}", "${recycler.alert.non.recyclable}", 0, function (k:com.sulake.habbo.window.utils.IAlertDialog, _arg_2:com.sulake.core.window.events.WindowEvent)
                {
                    k.dispose();
                });
                return;
            }
            this._Str_3602[slotId] = new _Str_3718(itemId, category, typeId, xxxExtra);
            this._Str_15040();
            this._Str_8448();
        }

        public function releaseSlot(k:Int)
        {
            if (!this.ready)
            {
                return;
            }
            if (this._Str_3602[k] == null)
            {
                return;
            }
            if (!this._habboCatalog.returnInventoryFurniFromRecycler(ASCompat.toInt(this._Str_3602[k].id)))
            {
                return;
            }
            this._Str_3602[k] = null;
            this._Str_15040();
            this._Str_8448();
        }

        public function executeRecycler()
        {
            var _local_3:_Str_3718 = null;
            if (!this.isReadyToRecycle())
            {
                return;
            }
            this._Str_6624 = _Str_13576;
            this._Str_8448();
            var k= new Array<ASAny>();
            var _local_2 = 0;
            while (_local_2 < this._Str_3602.length)
            {
                _local_3 = this._Str_3602[_local_2];
                if (_local_3 == null)
                {
                    return;
                }
                k.push(_local_3.id);
                _local_2++;
            }
            this._habboCatalog.sendRecycleItems(k);
            this._view._Str_20090();
        }

        public function isReadyToRecycle():Bool
        {
            if (((!this.ready) || (!this._habboCatalog.privateRoomSessionActive)))
            {
                return false;
            }
            if (this._Str_22951())
            {
                this._windowManager.alert("${generic.alert.title}", "${recycler.alert.trading}", 0, function (k:com.sulake.habbo.window.utils.IAlertDialog, _arg_2:com.sulake.core.window.events.WindowEvent)
                {
                    k.dispose();
                });
                return false;
            }
            return this._Str_23847();
        }

        public function _Str_19372(k:Bool)
        {
            if (k == false)
            {
                this.empty();
                this._Str_21753();
            }
            this._Str_8448();
        }

        function _Str_21753()
        {
            if (((!this._habboCatalog.privateRoomSessionActive) && this.ready))
            {
                this._windowManager.alert("${generic.alert.title}", "${recycler.alert.privateroom}", 0, function (k:com.sulake.habbo.window.utils.IAlertDialog, _arg_2:com.sulake.core.window.events.WindowEvent)
                {
                    k.dispose();
                });
            }
        }

        function _Str_15040()
        {
            if (((this._view == null) || (!this._Str_14201)))
            {
                return;
            }
            this._view._Str_15301();
        }

        function _Str_8448()
        {
            if (((this._view == null) || (!this._Str_14201)))
            {
                return;
            }
            this._view._Str_20203(this.isReadyToRecycle());
        }

        function _Str_23847():Bool
        {
            if (this._Str_3602 == null)
            {
                return false;
            }
            if (this._Str_3602.length < this._Str_7638)
            {
                return false;
            }
            var k = 0;
            while (k < this._Str_3602.length)
            {
                if (this._Str_3602[k] == null)
                {
                    return false;
                }
                k++;
            }
            return true;
        }

        function _Str_22951():Bool
        {
            return this._habboCatalog.tradingActive;
        }

        public function _Str_22273(k:Array<ASAny>)
        {
            var _local_3:PrizeLevelContainer = null;
            this._Str_3154 = new Array<ASAny>();
            var _local_2 = 0;
            while (_local_2 < k.length)
            {
                _local_3 = new PrizeLevelContainer(k[_local_2], this._habboCatalog);
                this._Str_3154.push(_local_3);
                _local_2++;
            }
        }

        public function getPrizeTable():Array<ASAny>
        {
            if (this._Str_3154 == null)
            {
                this._habboCatalog.getRecyclerPrizes();
                return null;
            }
            return this._Str_3154;
        }
    }

