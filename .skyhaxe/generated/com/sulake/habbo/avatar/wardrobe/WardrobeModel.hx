package com.sulake.habbo.avatar.wardrobe
;
    import com.sulake.habbo.avatar.common.ISideContentModel;
    import com.sulake.habbo.avatar.HabboAvatarEditor;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.avatar.OutfitData;
    import com.sulake.core.utils.ErrorReportStorage;
    import com.sulake.habbo.session.HabboClubLevelEnum;

     class WardrobeModel implements ISideContentModel 
    {
        var _controller:HabboAvatarEditor;
        var _view:WardrobeView;
        var _slots:Map;
        var _isInitialized:Bool = false;

        public function new(k:HabboAvatarEditor)
        {
            this._controller = k;
        }

        public function dispose()
        {
            var k:WardrobeSlot = null;
            this._controller = null;
            final _iter_ = this._slots; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
k  = _tmp_;
                k.dispose();
                k = null;
            }
            this._slots = null;
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
            this._isInitialized = false;
        }

        public function reset()
        {
            this._isInitialized = false;
        }

        function init()
        {
            var _local_2:WardrobeSlot = null;
            if (this._view != null)
            {
                this._view.dispose();
            }
            this._view = new WardrobeView(this);
            if (this._controller.handler != null)
            {
                this._controller.handler._Str_22376();
            }
            if (this._slots != null)
            {
                final _iter_ = this._slots; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
                {
_local_2  = _tmp_;
                    _local_2.dispose();
                    _local_2 = null;
                }
            }
            this._slots = new Map();
            var k= 1;
            while (k <= 10)
            {
                this._slots.add(k, new WardrobeSlot(this._view._Str_23743, this._controller, k, this._Str_21478(k)));
                k++;
            }
            this._isInitialized = true;
            this.updateView();
        }

        public var controller(get,never):HabboAvatarEditor;
public function  get_controller():HabboAvatarEditor
        {
            return this._controller;
        }

        public function getWindowContainer():IWindowContainer
        {
            if (!this._isInitialized)
            {
                this.init();
            }
            return this._view.getWindowContainer();
        }

        function updateView()
        {
            this._view.update();
        }

        public function _Str_15301(k:Int, _arg_2:Array<ASAny>)
        {
            var _local_3:WardrobeSlot = null;
            var _local_4:OutfitData = null;
            if (!this._isInitialized)
            {
                return;
            }
            if (_arg_2 == null)
            {
                ErrorReportStorage.addDebugData("WardrobeModel", "updateSlots: outfits is null!");
            }
            if (this._slots == null)
            {
                ErrorReportStorage.addDebugData("WardrobeModel", "updateSlots: _slots is null!");
            }
            if (checkNullIteratee(_arg_2)) for (_tmp_ in _arg_2)
            {
_local_4  = _tmp_;
                _local_3 = ASCompat.dynamicAs(this._slots.getValue(_local_4.slotId) , WardrobeSlot);
                if (_local_3 != null)
                {
                    _local_3.update(_local_4.figureString, _local_4.gender, this._Str_21478(_local_3.id));
                }
            }
        }

        function _Str_21478(k:Int):Bool
        {
            if (k <= 5)
            {
                return this._controller.manager.sessionData.clubLevel >= HabboClubLevelEnum.CLUB;
            }
            return this._controller.manager.sessionData.clubLevel >= HabboClubLevelEnum.VIP;
        }

        public var _Str_22986(get,never):Array<ASAny>;
public function  get__Str_22986():Array<ASAny>
        {
            return this._slots.getValues();
        }
    }

