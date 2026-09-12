package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetEvent;
    import com.sulake.habbo.window.widgets.IBadgeImageWidget;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.catalog.viewer.widgets.events.SelectProductEvent;

     class AddOnBadgeViewCatalogWidget extends CatalogWidget
    {
        public function new(k:IWindowContainer)
        {
            super(k);
        }

        override public function dispose()
        {
            if (!disposed)
            {
                events.removeEventListener(CatalogWidgetEvent.SELECT_PRODUCT, this.onSelectProduct);
                super.dispose();
            }
        }

        override public function init():Bool
        {
            if (!super.init())
            {
                return false;
            }
            _Str_2819(CatalogWidgetEnum.ADD_ON_BADGE_VIEW);
            events.addEventListener(CatalogWidgetEvent.SELECT_PRODUCT, this.onSelectProduct);
            return true;
        }

        function onSelectProduct(k:SelectProductEvent)
        {
            var _local_2:IBadgeImageWidget = null;
            if (((!disposed) && ASCompat.stringAsBool(k.offer.badgeCode)))
            {
                _local_2 = Std.downcast(cast(_window.findChildByName("badge"), IWidgetWindow).widget , IBadgeImageWidget);
                if (_local_2 != null)
                {
                    _local_2.badgeId = k.offer.badgeCode;
                }
            }
        }
    }

