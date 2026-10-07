package com.sulake.habbo.inventory.badges
;
    import com.sulake.habbo.inventory.IInventoryModel;
    import com.sulake.habbo.inventory.HabboInventory;
    import com.sulake.core.utils.Map;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.communication.messages.outgoing.inventory.badges.GetBadgesComposer;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.inventory._enum.UnseenItemCategoryEnum;
    import com.sulake.habbo.communication.messages.outgoing.inventory.badges.SetActivatedBadgesComposer;
    import com.sulake.habbo.inventory._enum.InventoryCategory;
    import flash.events.Event;
    import com.sulake.habbo.inventory.events.HabboInventoryTrackingEvent;

     class BadgesModel implements IInventoryModel 
    {
        public static inline final _Str_16949= -1;
        public static inline final _Str_8369= 0;
        public static inline final _Str_6557= 1;

        static inline final _Str_23733= 5;

        var _controller:HabboInventory;
        var _view:BadgesView;
        var _badges:Array<ASAny>;
        var _badgesInUse:Array<ASAny>;
        var _badgeIds:Map;
        var _assets:IAssetLibrary;
        var _communication:IHabboCommunicationManager;
        var _windowManager:IHabboWindowManager;
        var _disposed:Bool = false;

        public function new(k:HabboInventory, _arg_2:IHabboWindowManager, _arg_3:IHabboCommunicationManager, _arg_4:IAssetLibrary)
        {
            this._controller = k;
            this._windowManager = _arg_2;
            this._badges = new Array<ASAny>();
            this._badgesInUse = new Array<ASAny>();
            this._assets = _arg_4;
            this._communication = _arg_3;
            this._view = new BadgesView(this, _arg_2, _arg_4);
            this._badgeIds = new Map();
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            this._controller = null;
            this._windowManager = null;
            this._badges = null;
            this._badgesInUse = null;
            if (this._badgeIds != null)
            {
                this._badgeIds.dispose();
                this._badgeIds = null;
            }
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
            this._assets = null;
            this._communication = null;
        }

        public function onInventoryOpen()
        {
            this._communication.connection.send(new GetBadgesComposer());
        }

        public function _Str_23348():Int
        {
            return BadgesModel._Str_23733;
        }

        public function updateView()
        {
            if (this._view != null)
            {
                this._view._Str_18918(null);
            }
        }

        function _Str_2944()
        {
            if (this._view != null)
            {
                this._view._Str_2944();
            }
        }

        function _Str_17363(k:Badge)
        {
            this._badgesInUse.push(k);
            k.isInUse = true;
        }

        function _Str_16521(k:Badge)
        {
            var _local_2 = 0;
            while (_local_2 < this._badgesInUse.length)
            {
                if (this._badgesInUse[_local_2] == k)
                {
                    this._badgesInUse.splice(_local_2, 1);
                    k.isInUse = false;
                    return;
                }
                _local_2++;
            }
        }

        public function updateBadge(k:String, _arg_2:Bool, _arg_3:Int=0)
        {
            var _local_5:IAsset = null;
            var _local_6:XmlAsset = null;
            var _local_7:IWindowContainer = null;
            var _local_8 = false;
            var _local_9:Badge = null;
            if (_arg_3 > 0)
            {
                this._badgeIds.add(k, _arg_3);
            }
            var _local_4= this._Str_19103(k);
            if (_local_4 != null)
            {
                if (_local_4.isInUse != _arg_2)
                {
                    if (_arg_2)
                    {
                        this._Str_17363(_local_4);
                    }
                    else
                    {
                        this._Str_16521(_local_4);
                    }
                }
            }
            else
            {
                _local_5 = this._assets.getAssetByName("inventory_thumb_xml");
                _local_6 = cast(_local_5, XmlAsset);
                _local_7 = Std.downcast(this._windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(_local_6.content)) , IWindowContainer);
            _local_8 = this._controller.unseenItemTracker.isUnseen(UnseenItemCategoryEnum.BADGE, _arg_3);
                _local_9 = new Badge(k, _local_7, _local_8);
                if (_local_8)
                {
                    this._badges.unshift(_local_9);
                }
                else
                {
                    this._badges.push(_local_9);
                }
                if (_arg_2)
                {
                    this._Str_17363(_local_9);
                }
            }
        }

        function _Str_19103(k:String):Badge
        {
            var _local_3:Badge = null;
            var _local_2 = 0;
            while (_local_2 < this._badges.length)
            {
                _local_3 = this._badges[_local_2];
                if (_local_3.badgeId == k)
                {
                    return _local_3;
                }
                _local_2++;
            }
            return null;
        }

        public function _Str_24079(k:String)
        {
            var _local_3:Badge = null;
            var _local_2 = 0;
            while (_local_2 < this._badges.length)
            {
                _local_3 = this._badges[_local_2];
                if (_local_3.badgeId == k)
                {
                    this._badges.splice(_local_2, 1);
                    this._Str_16521(_local_3);
                    this.updateView();
                    return;
                }
                _local_2++;
            }
        }

        public function _Str_24883(k:String)
        {
            var _local_2= this._Str_19103(k);
            if (_local_2 != null)
            {
                if (_local_2.isInUse)
                {
                    this._Str_16521(_local_2);
                }
                else
                {
                    this._Str_17363(_local_2);
                }
                this._Str_23795();
            }
        }

        public function _Str_23795()
        {
            var _local_4:Badge = null;
            var k= new SetActivatedBadgesComposer();
            var _local_2= this._Str_5453(_Str_6557);
            var _local_3 = 0;
            while (_local_3 < _local_2.length)
            {
                _local_4 = _local_2[_local_3];
                k.addActivatedBadge(_local_4.badgeId);
                _local_3++;
            }
            this._communication.connection.send(k);
        }

        public function _Str_17509(k:String)
        {
            var _local_3:Badge = null;
            var _local_2 = 0;
            while (_local_2 < this._badges.length)
            {
                _local_3 = ASCompat.dynamicAs(this._badges[_local_2] , Badge);
                if (_local_3 != null)
                {
                    _local_3.Selected = (_local_3.badgeId == k);
                }
                _local_2++;
            }
            this._Str_2944();
        }

        public function _Str_22395()
        {
            var k= this._Str_17378();
            if (k != null)
            {
                return;
            }
            var _local_2= this._Str_5453(_Str_8369);
            if (((!(_local_2 == null)) && (_local_2.length > 0)))
            {
                k = ASCompat.dynamicAs(_local_2[0] , Badge);
                k.Selected = true;
                this.updateView();
                return;
            }
            var _local_3= this._Str_5453(_Str_6557);
            if (((!(_local_3 == null)) && (_local_3.length > 0)))
            {
                k = ASCompat.dynamicAs(_local_3[0] , Badge);
                k.Selected = true;
                this.updateView();
            }
        }

        public function _Str_17378(k:Int=-1):Badge
        {
            var _local_4:Badge = null;
            var _local_2= this._Str_5453(k);
            var _local_3 = 0;
            while (_local_3 < _local_2.length)
            {
                _local_4 = _local_2[_local_3];
                if (_local_4.Selected)
                {
                    return _local_4;
                }
                _local_3++;
            }
            return null;
        }

        public function _Str_5453(k:Int=-1):Array<ASAny>
        {
            var _local_2:Array<ASAny> = null;
            var _local_3:Badge = null;
            switch (k)
            {
                case _Str_16949:
                    return this._badges;
                case _Str_8369:
                    _local_2 = new Array<ASAny>();
                    final _iter_ = this._badges; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
_local_3  = _tmp_;
                        if (!_local_3.isInUse)
                        {
                            _local_2.push(_local_3);
                        }
                    }
                    return _local_2;
                case _Str_6557:
                    return this._badgesInUse;
            }
            Logger.log(["Unexpected filter. Returning an empty array to maintain backward compatibility"]);
            return new Array<ASAny>();
        }

        public function _Str_24207(k:Int):Badge
        {
            return this._Str_11080(k, _Str_6557);
        }

        public function _Str_26333(k:Int):Badge
        {
            return this._Str_11080(k, _Str_8369);
        }

        public function _Str_11080(k:Int, _arg_2:Int=-1):Badge
        {
            var _local_3= this._Str_5453(_arg_2);
            if (((k < 0) || (k >= _local_3.length)))
            {
                return null;
            }
            return _local_3[k];
        }

        public function getWindowContainer():IWindowContainer
        {
            return this._view.getWindowContainer();
        }

        public function onInventoryClose()
        {
            if (this._view.isVisible)
            {
                this._Str_4409();
            }
        }

        public function initCategory(k:String)
        {
            if (((k == InventoryCategory.BADGES) && this._controller.isVisible))
            {
                this._controller.events.dispatchEvent(new Event(HabboInventoryTrackingEvent.HABBO_INVENTORY_TRACKING_EVENT_BADGES));
            }
        }

        public function onCategorySwitch(k:String)
        {
        }

        public var controller(get,never):HabboInventory;
public function  get_controller():HabboInventory
        {
            return this._controller;
        }

        public function _Str_4409()
        {
            var k:Badge = null;
            if (!this._controller._Str_23029)
            {
                return;
            }
            this._controller.unseenItemTracker._Str_8813(UnseenItemCategoryEnum.BADGE);
            final _iter_ = this._badges; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k.isUnseen = false;
            }
            this.updateView();
            this._controller._Str_6956();
        }

        public function onSubcategorySwitch(k:String)
        {
            this._Str_17509(k);
        }
    }

