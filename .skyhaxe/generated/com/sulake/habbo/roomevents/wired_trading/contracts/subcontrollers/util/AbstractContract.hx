package com.sulake.habbo.roomevents.wired_trading.contracts.subcontrollers.util
;
    import com.sulake.core.communication.util.Short;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementRulesDefinition;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.contracts.ChestContractContentsMessageParser;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_trading.AbstractUbuntuWiredUI;
    import com.sulake.habbo.roomevents.wired_trading.contracts.WiredContractController;
    import com.sulake.habbo.roomevents.wired_trading.contracts.subcontrollers.IContractView;

     class AbstractContract extends AbstractUbuntuWiredUI implements IContractView
    {
        var _contractId:Int = -1;
        var _parent:WiredContractController;

        public function new(parent:WiredContractController,
            presetManager:PresetManager)
        {
            super(parent.roomEvents, presetManager);
            this._parent = parent;
        }

        override function  get_isBoundToParentRect():Bool { return true; }
                public var contractId(get,set):Int;
public function  get_contractId():Int { return this._contractId; }
public function  set_contractId(value:Int):Int{ return this._contractId = value; }
        var parentController(get,never):WiredContractController;
function  get_parentController():WiredContractController { return this._parent; }
        override public function onSaveClicked() { this._parent.saveContract(this); }

        override function hideFrame()
        {
            if (isShowing())
            {
                this._parent.cacheWindowLocation(window);
                this._parent.addEditContractElement.hide();
            }
            super.hideFrame();
        }

        public function show(contents:ChestContractContentsMessageParser)
        {
            this.contractId = contents.contractId;
            this.footerPreset.saveButtonDisabled =
                !this.roomEvents.wiredMenu.hasWritePermission;
        }

        function createNewDefinitionFromUI():TradeRequirementRulesDefinition
        {
            return null;
        }

        public function addContentsToComposer(data:Array<ASAny>)
        {
            data.push(this.contractId);
            data.push(new Short(this.contractType()));
            this.createNewDefinitionFromUI().addToComposer(data);
        }

        public function contractType():Int { return 0; }
        public function validate():String { return null; }

        override public function dispose()
        {
            if (disposed) return;
            this._parent = null;
            super.dispose();
        }
    }

