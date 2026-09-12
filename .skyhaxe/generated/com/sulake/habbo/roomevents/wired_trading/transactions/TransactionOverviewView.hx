package com.sulake.habbo.roomevents.wired_trading.transactions
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IScrollableGridWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions.WiredTransactionItemTypeCount;

    /** July's pooled furniture/credit summary grid. */
     final class TransactionOverviewView implements IDisposable
    {
        static inline final MAX_POOL_SIZE= 15;
        var _window:IWindowContainer;
        var _template:IRegionWindow;
        var _active:Vector<TransactionItemView>;
        var _pool:Vector<TransactionItemView>;
        var _disposed:Bool = false;

        public function new(window:IWindowContainer)
        {
            this._window = window;
            this._template = Std.downcast(this.grid.removeGridItemAt(0) , IRegionWindow);
            this._active = new Vector<TransactionItemView>();
            this._pool = new Vector<TransactionItemView>();
        }

        public function initialize(
            coins:Int,
            itemTypes:Vector<WiredTransactionItemTypeCount>,
            totalFurni:Int,
            incomplete:Bool)
        {
var item:WiredTransactionItemTypeCount  = null, view:TransactionItemView  = null;            this.clear();
            if (coins > 0)
            {
                this._active.push(this.claim(coins, TransactionItemView.TYPE_COINS));
            }
            var retained = 0;
            if (checkNullIteratee(itemTypes)) for (_tmp_ in itemTypes)
            {
item = _tmp_;
                retained += item.amount;
                this._active.push(this.claim(
                    item.amount, TransactionItemView.TYPE_FURNI, item));
            }
            if (incomplete && retained < totalFurni)
            {
                this._active.push(this.claim(totalFurni - retained,
                    TransactionItemView.TYPE_INCOMPLETE));
            }
            final _iter_ = this._active; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
view = _tmp_;
                this.grid.addGridItem(view.window);
            }
            this.emptyText.visible = this.grid.numGridItems == 0;
        }

        function claim(amount:Int, kind:Int,
                               item:WiredTransactionItemTypeCount=null):TransactionItemView
        {
            var result= this._pool.length > 0
                ? this._pool.pop() : new TransactionItemView(this._template);
            result.initialize(amount, kind, item == null ? null : item.type);
            return result;
        }
        public function clear()
        {
var view:TransactionItemView  = null;            this.grid.removeGridItems();
            final _iter_ = this._active; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
view = _tmp_;
                if (this._pool.length < MAX_POOL_SIZE)
                {
                    view.recycle();
                    this._pool.push(view);
                }
                else
                {
                    view.dispose();
                }
            }
            this._active.length = 0;
        }
        var grid(get,never):IScrollableGridWindow;
function  get_grid():IScrollableGridWindow
        {
            return Std.downcast(this._window.findChildByName("item_grid")
, IScrollableGridWindow);
        }
        var emptyText(get,never):ITextWindow;
function  get_emptyText():ITextWindow
        {
            return Std.downcast(this._window.findChildByName("empty_text") , ITextWindow);
        }
        public function dispose()
        {
var view:TransactionItemView  = null;            if (this._disposed) { return; }
            this.clear();
            final _iter_ = this._pool; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
view = _tmp_;
                view.dispose();
            }
            this._pool = null;
            this._active = null;
            this._template.dispose();
            this._template = null;
            this._window = null;
            this._disposed = true;
        }
        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }
    }

