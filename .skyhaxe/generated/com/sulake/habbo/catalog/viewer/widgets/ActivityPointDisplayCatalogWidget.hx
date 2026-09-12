package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.habbo.catalog.purse.PurseUpdateEvent;
    import com.sulake.habbo.catalog.purse.ActivityPointTypeEnum;
    import com.sulake.habbo.catalog.IPurchasableOffer;

     class ActivityPointDisplayCatalogWidget extends CatalogWidget 
    {
        public function new(k:IWindowContainer)
        {
            super(k);
        }

        override public function dispose()
        {
            var k= cast(page.viewer.catalog, HabboCatalog);
            k.events.removeEventListener(PurseUpdateEvent.CATALOG_PURSE_UPDATE, this.onPurseUpdate);
            super.dispose();
        }

        override public function init():Bool
        {
            if (!super.init())
            {
                return false;
            }
            _Str_2819(CatalogWidgetEnum.ACTIVITY_POINT_DISPLAY);
            _window.findChildByName("activity_points_txt").caption = "";
            var k= cast(page.viewer.catalog, HabboCatalog);
            k.events.addEventListener(PurseUpdateEvent.CATALOG_PURSE_UPDATE, this.onPurseUpdate);
            return this._Str_19249();
        }

        function _Str_19249():Bool
        {
            if (disposed)
            {
                return false;
            }
            if (_window == null)
            {
                return false;
            }
            var k= this._Str_13323();
            if (((k < 1) || (!ActivityPointTypeEnum.isVisible(k))))
            {
                _window.visible = false;
                return false;
            }
            var _local_2= cast(page.viewer.catalog, HabboCatalog);
            var _local_3= ("catalog.purchase.youractivitypoints." + Std.string(k));
            _local_2.localization.registerParameter(_local_3, "activitypoints", ("" + Std.string(_local_2.getPurse().getActivityPointsForType(k))));
            _window.findChildByName("activity_points_txt").caption = _local_2.localization.getLocalization(_local_3);
            var _local_4= _window.findChildByName("activity_point_icon");
            _local_4.style = ActivityPointTypeEnum.getIconStyleFor(k, _local_2, true);
            _window.visible = true;
            return true;
        }

        function onPurseUpdate(k:PurseUpdateEvent)
        {
            this._Str_19249();
        }

        function _Str_13323():Int
        {
            var k:IPurchasableOffer = null;
            if (((page == null) || (page.offers == null)))
            {
                return 0;
            }
            final _iter_ = page.offers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                if (k.activityPointType > 0)
                {
                    return k.activityPointType;
                }
            }
            return 0;
        }
    }

