package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementNode;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers.views.ChestItemTypeRenderableWrapper;
    import com.sulake.habbo.window.widgets.IProductIconWidget;

     class TradeRuleNodeView implements IDisposable
    {
        static var UNIQUE_ID_COUNTER:UInt = 0;

        var _editor:TradeRuleEditorPreset;
        var _node:TradeRequirementNode;
        var _window:IRegionWindow;
        var _hovered:Bool = false;
        var _closeHovered:Bool = false;
        var _showClose:Bool = false;
        var _uniqueId:UInt = 0;
        var _disposed:Bool = false;

        public function new(template:IRegionWindow)
        {
            this._uniqueId = UNIQUE_ID_COUNTER++;
            this._window = Std.downcast(template.clone() , IRegionWindow);
            this._window.addEventListener(WindowMouseEvent.OVER, this.onHover);
            this._window.addEventListener(WindowMouseEvent.OUT, this.onHoverEnd);
            this.closeRegion.addEventListener(WindowMouseEvent.OVER, this.onCloseHover);
            this.closeRegion.addEventListener(WindowMouseEvent.OUT, this.onCloseHoverEnd);
            this._window.addEventListener(WindowMouseEvent.CLICK, this.onClick);
            this.closeRegion.addEventListener(WindowMouseEvent.CLICK, this.onCloseClick);
        }

        public function initialize(editor:TradeRuleEditorPreset,
            node:TradeRequirementNode, showClose:Bool = true)
        {
            this._editor = editor;
            this._node = node;
            this._showClose = showClose;
            this._hovered = false;
            this._closeHovered = false;
            Util.disableSection(this._window, false);
            this.updateUI();
        }

        public function release()
        {
            this._editor = null;
            this._node = null;
            this._showClose = true;
        }

        function onCloseClick(event:WindowMouseEvent)
        {
            if (this._node != null) this._editor.removeNode(this);
        }

        function onClick(event:WindowMouseEvent)
        {
            if (this._node != null) this._editor.editNode(this);
        }

        function updateUI()
        {
            this.closeRegion.visible = this._showClose &&
                (this._hovered || this._closeHovered);
            this.quantityAmount.text = Std.string(this._node.amount);
            this.quantityBorder.visible = this._node.amount != 1 ||
                this._node.type == TradeRequirementNode.TYPE_COIN;
            var widget= Std.downcast(this.iconWidget.widget , IProductIconWidget);
            if (this._node.type == TradeRequirementNode.TYPE_FURNI)
            {
                this.iconWidget.visible = true;
                widget.productInfo = this._node.itemType == null ? null :
                    new ChestItemTypeRenderableWrapper(this._node.itemType);
                this.coinsIcon.visible = false;
            }
            else
            {
                this.iconWidget.visible = false;
                widget.productInfo = null;
                this.coinsIcon.visible = true;
            }
        }

        function onHoverEnd(event:WindowMouseEvent) { this._hovered = false; this.updateUI(); }
        function onHover(event:WindowMouseEvent) { this._hovered = true; this.updateUI(); }
        function onCloseHoverEnd(event:WindowMouseEvent) { this._closeHovered = false; this.updateUI(); }
        function onCloseHover(event:WindowMouseEvent) { this._closeHovered = true; this.updateUI(); }

        public var window(get,never):IRegionWindow;
public function  get_window():IRegionWindow { return this._window; }
                public var node(get,set):TradeRequirementNode;
public function  get_node():TradeRequirementNode { return this._node; }
public function  set_node(value:TradeRequirementNode):TradeRequirementNode{ this._node = value; this.updateUI(); return value;
}
        public var uniqueID(get,never):UInt;
public function  get_uniqueID():UInt { return this._uniqueId; }

        public function dispose()
        {
            if (this._disposed) return;
            this._editor = null;
            this._node = null;
            this._window.dispose();
            this._window = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }
        var iconWidget(get,never):IWidgetWindow;
function  get_iconWidget():IWidgetWindow { return Std.downcast(this._window.findChildByName("element_icon_widget") , IWidgetWindow); }
        var coinsIcon(get,never):IStaticBitmapWrapperWindow;
function  get_coinsIcon():IStaticBitmapWrapperWindow { return Std.downcast(this._window.findChildByName("coins_icon") , IStaticBitmapWrapperWindow); }
        var quantityBorder(get,never):IWindowContainer;
function  get_quantityBorder():IWindowContainer { return Std.downcast(this._window.findChildByName("quantity_border") , IWindowContainer); }
        var quantityAmount(get,never):ITextWindow;
function  get_quantityAmount():ITextWindow { return Std.downcast(this._window.findChildByName("quantity_amount") , ITextWindow); }
        var closeRegion(get,never):IRegionWindow;
function  get_closeRegion():IRegionWindow { return Std.downcast(this._window.findChildByName("close_region") , IRegionWindow); }
    }

