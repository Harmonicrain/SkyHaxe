package com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.DropBaseController;
    import com.sulake.core.window.components.IDropMenuWindow;
    import com.sulake.core.window.events.WindowEvent;

    /**
     * Dropdown wrapper supporting "advanced" options hidden behind a show-more entry
     * (May ExpandableDropdown). Clean DropMenu has no WE_COLLAPSE event; the collapse
     * hook maps to WINDOW_EVENT_CLOSED, and openMenu maps to DropBaseController.open().
     */
     class ExpandableDropdown implements IDisposable
    {
        var _disposed:Bool = false;
        var _dropdown:IDropMenuWindow;
        var _onChangeCallback:ASFunction;
        var _showingAdvanced:Bool = false;
        var _ignoreNextCollapse:Bool = false;
        var _lastSelectedId:Float = 0;
        var _allOptions:Vector<ExpandableDropdownOption> = new Vector();
        var _showMoreLocalization:String;
        var _visibleOptions:Vector<ExpandableDropdownOption> = new Vector();

        public function new(_arg_1:IDropMenuWindow, _arg_2:String, _arg_3:ASFunction = null)
        {
            this._dropdown = _arg_1;
            this._showMoreLocalization = _arg_2;
            this._onChangeCallback = _arg_3;
            this._dropdown.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this.onSelectAction);
            this._dropdown.addEventListener(WindowEvent.WINDOW_EVENT_CLOSED, this.onDropdownCollapse);
        }

        public function init(_arg_1:Vector<ExpandableDropdownOption>, _arg_2:Int)
        {
            this._allOptions = _arg_1;
            this._ignoreNextCollapse = false;
            this._showingAdvanced = false;
            this._lastSelectedId = 0;
            this.populate(_arg_2);
        }

        public var dropdownOptions(get,never):Vector<ExpandableDropdownOption>;
public function  get_dropdownOptions():Vector<ExpandableDropdownOption>
        {
            return this._visibleOptions;
        }

        function populate(_arg_1:Int, _arg_2:Bool = false)
        {
var _local_5:ExpandableDropdownOption  = null;            var _local_3= -1;
            this._visibleOptions.splice(0, this._visibleOptions.length);
            var _local_4= new Vector<String>();
            final _iter_ = this._allOptions; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_5 = _tmp_;
                if (_arg_1 == _local_5.id)
                {
                    _local_3 = this._visibleOptions.length;
                    if (_local_5.isAdvanced && (!_arg_2))
                    {
                        this._showingAdvanced = true;
                        this.populate(_arg_1, true);
                        return;
                    }
                }
                if ((!_local_5.isAdvanced) || _arg_2)
                {
                    this._visibleOptions.push(_local_5);
                    _local_4.push(_local_5.displayString);
                }
            }
            if (this.advancedOptionsAvailable && (!_arg_2))
            {
                _local_4.push(this._showMoreLocalization);
            }
            this._ignoreNextCollapse = true;
            this._dropdown._Str_24893(_local_4);
            if (_local_3 != -1)
            {
                this._dropdown.selection = _local_3;
                this._lastSelectedId = _arg_1;
            }
            else
            {
                this._lastSelectedId = -1;
            }
        }

        var advancedOptionsAvailable(get,never):Bool;
function  get_advancedOptionsAvailable():Bool
        {
var _local_1:ExpandableDropdownOption  = null;            final _iter_ = this._allOptions; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_1 = _tmp_;
                if (_local_1.isAdvanced)
                {
                    return true;
                }
            }
            return false;
        }

        function onSelectAction(_arg_1:WindowEvent)
        {
            var _local_2:DropBaseController = null;
            if (this._dropdown.selection >= this._visibleOptions.length)
            {
                this._showingAdvanced = true;
                this.populate(Std.int(this._lastSelectedId), true);
                _local_2 = ASCompat.reinterpretAs(this._dropdown , DropBaseController);
                if (_local_2 != null)
                {
                    _local_2.open();
                }
                return;
            }
            this._lastSelectedId = this.selectedOptionId;
            if (this._onChangeCallback != null)
            {
                this._onChangeCallback(this.selectedOption);
            }
        }

        function onDropdownCollapse(_arg_1:WindowEvent)
        {
            if (this._ignoreNextCollapse)
            {
                this._ignoreNextCollapse = false;
                return;
            }
            if (this._showingAdvanced && ((this.selectedOption == null) || (!this.selectedOption.isAdvanced)))
            {
                this._showingAdvanced = false;
                this.populate(Std.int(this.selectedOptionId), false);
            }
        }

        public var selectedOption(get,never):ExpandableDropdownOption;
public function  get_selectedOption():ExpandableDropdownOption
        {
            var _local_1:Float = this._dropdown.selection;
            if ((_local_1 < 0) || (_local_1 >= this._visibleOptions.length))
            {
                return null;
            }
            return this._visibleOptions[Std.int(_local_1)];
        }

        
        public var selectedOptionId(get,set):Float;
public function  get_selectedOptionId():Float
        {
            return (this.selectedOption == null) ? Math.NaN : this.selectedOption.id;
        }
public function  set_selectedOptionId(_arg_1:Float):Float        {
            this.init(this._allOptions, Std.int(_arg_1));
return _arg_1;
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._dropdown.dispose();
            this._dropdown = null;
            this._onChangeCallback = null;
            this._allOptions = null;
            this._showMoreLocalization = null;
            this._visibleOptions = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }
    }

