package com.sulake.habbo.inventory.wired_trading.requirements
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestItemType;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirement;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementNode;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementRule;
    import com.sulake.habbo.inventory.items.GroupItem;

    /**
     * Precomputed July rule filter for the local user's inventory.
     */
     class TradeRequirementWrapper
    {
        var _requirement:TradeRequirement;
        var _canOfferCreditFurni:Bool = false;
        var _floorTypes:ASDictionary<ASAny,ASAny>;
        var _wallTypes:ASDictionary<ASAny,ASAny>;
        var _posterIds:ASDictionary<ASAny,ASAny>;

        public function new(requirement:TradeRequirement)
        {
var rule:TradeRequirementRule  = null, node:TradeRequirementNode  = null, itemType:ChestItemType  = null;            this._requirement = requirement;
            if (requirement.rules != null && requirement.rules.youGiveRule != null)
            {
                this._floorTypes = new ASDictionary<ASAny,ASAny>();
                this._wallTypes = new ASDictionary<ASAny,ASAny>();
                this._posterIds = new ASDictionary<ASAny,ASAny>();
                final _iter_ = requirement.rules.youGiveRule; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
rule = _tmp_;
                    final _iter_ = rule.nodes; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
node = _tmp_;
                        if (node.type == TradeRequirementNode.TYPE_COIN)
                        {
                            this._canOfferCreditFurni = true;
                        }
                        else if (node.type == TradeRequirementNode.TYPE_FURNI)
                        {
itemType= node.itemType;
                            if (itemType == null)
                            {
                                continue;
                            }
                            if (itemType.isWallItem)
                            {
                                this._wallTypes[itemType.typeId] = true;
                                if (itemType.legacyPosterId.length > 0)
                                {
                                    this._posterIds[itemType.legacyPosterId] = true;
                                }
                            }
                            else
                            {
                                this._floorTypes[itemType.typeId] = true;
                            }
                        }
                    }
                }
            }
        }

        public var requirement(get,never):TradeRequirement;
public function  get_requirement():TradeRequirement
        {
            return this._requirement;
        }

        public function canOfferCreditFurni():Bool
        {
            return this._canOfferCreditFurni;
        }

        public function canOfferNormalFurni(group:GroupItem):Bool
        {
            if (this._floorTypes == null || this._wallTypes == null || this._posterIds == null)
            {
                return false;
            }
            var item= group._Str_3205();
            if (item == null)
            {
                return false;
            }
            if (!item.isWallItem)
            {
                return this._floorTypes.exists(item.type );
            }
            if (item.category == 6
                && !this._posterIds.exists(item.stuffData.getLegacyString() ))
            {
                return false;
            }
            return this._wallTypes.exists(item.type );
        }
    }

