package com.sulake.habbo.inventory.wired_trading.requirements
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.catalog._enum.ProductTypeEnum;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirement;
    import com.sulake.habbo.inventory.items.GroupItem;
    import com.sulake.habbo.inventory.wired_trading.WiredTradingModel;

     class WiredTradeRequirementsModel implements IDisposable
    {
        var _tradingModel:WiredTradingModel;
        var _wrapper:TradeRequirementWrapper;
        var _view:WiredTradeRequirementsView;
        var _disposed:Bool = false;

        public function new(tradingModel:WiredTradingModel)
        {
            this._tradingModel = tradingModel;
            this._view = new WiredTradeRequirementsView(this);
        }

        public function setRequirements(requirement:TradeRequirement, showImmediate:Bool)
        {
            this._wrapper = new TradeRequirementWrapper(requirement);
            this._view.requirementsUpdated(requirement, showImmediate);
        }

        public function requirementsStateUpdated()
        {
            this._view.requirementsStateUpdated();
        }

        public function highlightRefresh()
        {
            this._view.highlightRefresh();
        }

        public var tradingModel(get,never):WiredTradingModel;
public function  get_tradingModel():WiredTradingModel
        {
            return this._tradingModel;
        }

        public var requirement(get,never):TradeRequirement;
public function  get_requirement():TradeRequirement
        {
            return this._wrapper == null ? null : this._wrapper.requirement;
        }

        public function canOfferFurni(group:GroupItem):Bool
        {
            if (this._wrapper == null)
            {
                return true;
            }
            if (group._Str_25861(1).length == 0)
            {
                return false;
            }

            var item= group._Str_3205();
            if (item == null)
            {
                return false;
            }
            var productType= item.isWallItem
                ? ProductTypeEnum.WALL : ProductTypeEnum.FLOOR;
            var data=
                this._tradingModel.inventory.getFurnitureData(item.type, productType);
            var className= data == null ? "" : data.className.toUpperCase();
            var isCreditFurni= className.indexOf("CF_") == 0
                || className.indexOf("CFC_") == 0;

            switch (this._wrapper.requirement.type)
            {
                case TradeRequirement.TYPE_ANY_FURNI:
                    return true;
                case TradeRequirement.TYPE_NORMAL_FURNI:
                    return !isCreditFurni;
                case TradeRequirement.TYPE_CREDIT_FURNI:
                    return isCreditFurni;
                case TradeRequirement.TYPE_RULES:
                    return isCreditFurni
                        ? this._wrapper.canOfferCreditFurni()
                        : this._wrapper.canOfferNormalFurni(group);
            }
            return true;
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._view.dispose();
            this._view = null;
            this._tradingModel = null;
            this._wrapper = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }
    }

