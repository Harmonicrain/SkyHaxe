package com.sulake.habbo.catalog.viewer.widgets.events
;
    import flash.events.Event;

     class CatalogWidgetBuilderSubscriptionUpdatedEvent extends Event 
    {
        public function new(k:Bool=false, _arg_2:Bool=false)
        {
            super(CatalogWidgetEvent.BUILDER_SUBSCRIPTION_UPDATED, k, _arg_2);
        }
    }

