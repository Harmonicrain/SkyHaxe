package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker
;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** Per-room recent-selection history and pooled node views used by July's picker. */
     class NewVariablePickerHelper
    {
        static inline final MAX_HISTORY= 20;

        var _roomEvents:HabboUserDefinedRoomEvents;
        var _history:Map = new Map();
        var _templates:Map = new Map();
        var _templateOwners:Map = new Map();
        var _pooledViews:Map = new Map();

        public function new(roomEvents:HabboUserDefinedRoomEvents)
        {
            this._roomEvents = roomEvents;
        }

        public function addToHistory(variable:WiredVariable)
        {
            if (variable == null || this._roomEvents.roomId == 0) { return; }
            var roomId= this._roomEvents.roomId;
            if (!this._history.hasKey(roomId)) { this._history.add(roomId, new Map()); }
            var roomHistory= ASCompat.dynamicAs(this._history.getValue(roomId) , Map);
            if (!roomHistory.hasKey(variable.variableTarget))
            {
                roomHistory.add(variable.variableTarget, new Vector<String>());
            }
            var values= ASCompat.asVector(roomHistory.getValue(variable.variableTarget) , (_ : String));
            var index= values.indexOf(variable.variableId);
            if (index >= 0) { values.splice(index, 1); }
            values.unshift(variable.variableId);
            if (values.length > MAX_HISTORY) { values.pop(); }
        }

        public function getHistory(variableTarget:Int):Vector<String>
        {
            var roomHistory= ASCompat.dynamicAs(this._history.getValue(this._roomEvents.roomId) , Map);
            if (roomHistory == null || !roomHistory.hasKey(variableTarget)) { return new Vector<String>(); }
            return Vector.ofArray((roomHistory.getValue(variableTarget) : Array<String>)).concat();
        }

        public function acquireNodeView(style:WiredStyle):IRegionWindow
        {
var layout:IWindowContainer  = null;            var pool= ASCompat.asVector(this._pooledViews.getValue(style.name) , (_ : IRegionWindow));
            if (pool != null && pool.length > 0) { return pool.pop(); }
            if (!this._templates.hasKey(style.name))
            {
layout= Std.downcast(this._roomEvents.wiredCtrl.presetManager.createLayout("search_tree_dropdown") , IWindowContainer);
                this._templates.add(style.name, layout.findChildByName("node_template"));
                this._templateOwners.add(style.name, layout);
            }
            return Std.downcast(cast(this._templates.getValue(style.name), IRegionWindow).clone() , IRegionWindow);
        }

        public function releaseNodeView(style:WiredStyle, view:IRegionWindow)
        {
            var pool= ASCompat.asVector(this._pooledViews.getValue(style.name) , (_ : IRegionWindow));
            if (pool == null)
            {
                pool = new Vector<IRegionWindow>();
                this._pooledViews.add(style.name, pool);
            }
            pool.push(view);
        }

        public function dispose()
        {
var owner:IWindow  = null, pool:Vector<IRegionWindow>  = null, view:IRegionWindow  = null;            final _iter_ = this._templateOwners.getValues(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_) { owner = _tmp_;
owner.dispose(); }
            final _iter_ = this._pooledViews.getValues(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
pool = _tmp_;
                if (checkNullIteratee(pool)) for (_tmp_ in pool) { view = _tmp_;
view.dispose(); }
            }
            this._history.dispose();
            this._templates.dispose();
            this._templateOwners.dispose();
            this._pooledViews.dispose();
            this._roomEvents = null;
        }
    }

