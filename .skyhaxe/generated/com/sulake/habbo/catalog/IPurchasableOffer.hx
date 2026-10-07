package com.sulake.habbo.catalog
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.catalog.viewer.ICatalogPage;
    import com.sulake.habbo.catalog.viewer.IProduct;
    import com.sulake.habbo.catalog.viewer.IProductContainer;
    import com.sulake.habbo.catalog.viewer.IGridItem;

     interface IPurchasableOffer extends IDisposable 
    {
        var offerId(get,never):Int;
        var priceInActivityPoints(get,never):Int;
        var activityPointType(get,never):Int;
        var priceInCredits(get,never):Int;
                var page(get,set):ICatalogPage;
        var priceType(get,never):String;
        var product(get,never):IProduct;
        var productContainer(get,never):IProductContainer;
        var gridItem(get,never):IGridItem;
        var localizationId(get,never):String;
        var bundlePurchaseAllowed(get,never):Bool;
        var isRentOffer(get,never):Bool;
        var giftable(get,never):Bool;
        var pricingModel(get,never):String;
                var previewCallbackId(get,set):Int;
        var clubLevel(get,never):Int;
        var badgeCode(get,never):String;
        var localizationName(get,never):String;
        var localizationDescription(get,never):String;
    }

