package com.sulake.habbo.communication.messages.parser.habbicons
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.catalog.habbicons.HabbiconCollectionData;
    import com.sulake.habbo.catalog.habbicons.HabbiconOwnedItem;
    import com.sulake.habbo.catalog.habbicons.HabbiconShopItem;

     class HabbiconWireParsers
    {
        public static function readOwnedItem(wrapper:IMessageDataWrapper):HabbiconOwnedItem
        {
            var item= new HabbiconOwnedItem();
            item.habbiconId = wrapper.readInteger();
            item.habbiconState = wrapper.readInteger();
            return item;
        }

        public static function readShopItem(wrapper:IMessageDataWrapper):HabbiconShopItem
        {
            var item= new HabbiconShopItem();
            item.habbiconId = wrapper.readInteger();
            item.name = wrapper.readString();
            item.collectionId = wrapper.readInteger();
            item.state = wrapper.readInteger();
            item.priceCredits = wrapper.readInteger();
            item.priceActivityPoints = wrapper.readInteger();
            item.activityPointType = wrapper.readInteger();
            return item;
        }

        public static function readCollection(wrapper:IMessageDataWrapper):HabbiconCollectionData
        {
var index = 0;            var count = 0;
            var index = 0;
            var collection= new HabbiconCollectionData();
            collection.collectionId = wrapper.readInteger();
            collection.name = wrapper.readString();
            collection.completed = wrapper.readBoolean();
            collection.rewardHabbiconId = wrapper.readInteger();
            collection.rewardState = wrapper.readInteger();
            collection.priceCredits = wrapper.readInteger();
            collection.priceActivityPoints = wrapper.readInteger();
            collection.activityPointType = wrapper.readInteger();
            collection.habbicons = [];
            count = wrapper.readInteger();
            for (_tmp_ in 0...count)
            {
index= _tmp_;
                collection.habbicons.push(readShopItem(wrapper));
            }
            return collection;
        }

	public function new() {}
    }

