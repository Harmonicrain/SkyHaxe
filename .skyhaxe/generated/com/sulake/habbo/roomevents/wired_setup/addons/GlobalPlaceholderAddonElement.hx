package com.sulake.habbo.roomevents.wired_setup.addons
;
 import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
 import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.SharedGlobalPlaceholder;
 import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.SharedGlobalPlaceholderList;
 import com.sulake.habbo.roomevents.WiredCapabilityCodes;
 import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
 import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
 import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
 import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
 import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
 import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
 import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
 import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
 import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextInputPreset;
 import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.NamedDropdownPreset;
 import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.PlaceholderNameSection;
 import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
 /** July addon 2000 global-placeholder editor; context reference list is parsed by WiredContext. */
  class GlobalPlaceholderAddonElement extends DefaultElement {
  var _name:PlaceholderNameSection;var _mode:RadioGroupPreset;var _value:TextInputPreset;var _rooms:NamedDropdownPreset;var _placeholders:NamedDropdownPreset;var _references:SharedGlobalPlaceholderList;
  override public function  get_code():Int{return AddonCodes.GLOBAL_PLACEHOLDER;}override public function  get_inputMode():Int{return DefaultElement.INPUTS_TYPE_UI_BUILDER;}override public function  get_requiredCapability():Int{return WiredCapabilityCodes.ADDONS|WiredCapabilityCodes.VARIABLES|WiredCapabilityCodes.VARIABLE_SYNC;}
  override public function buildInputs(m:PresetManager,s:WiredStyle,b:WiredUIBuilder){this._name=m.createPlaceholderNameSection(this.l("texts.placeholder_name"),"$");this._value=m.createTextInput(new TextInputParam("",100));this._rooms=m.createNamedDropdown(new DropdownParam(this.l("room_selection.tooltip"),null,this.onRoom),this.l("room_selection"));this._placeholders=m.createNamedDropdown(new DropdownParam(this.l("placeholder_selection.tooltip"),null),this.l("placeholder_selection"));this._mode=m.createRadioGroup([new RadioButtonParam(0,this.l("from_value"),null,this._value),new RadioButtonParam(1,this.l("from_another_room"),null,m.createSimpleListView(true,[this._rooms,this._placeholders]))]);b.addElements([this._name,m.createSection(this.l("choose_type"),this._mode)]);}
  override public function onEditStart(d:Triggerable){var p:Array<ASAny>=(cast d.stringData.split("\t"));var mode=d.intData.length>0?ASCompat.toInt(d.intData[0]):0;this._name.placeholderName=p.length>0?ASCompat.toString(p[0]):"";this._references=d.wiredContext.referencePlaceholderList;this._mode.setOptionDisabled(1,this._references==null);this._mode.setOptionDisabled(0,this._references==null&&mode==1);this._mode.selected=mode;var rooms=this.roomOptions();this._rooms.reinit(rooms,d.intData.length>2?ASCompat.toInt(d.intData[2]):-1);if(mode==0)this._value.text=p.length>1?ASCompat.toString(p[1]):"";else this.initPlaceholders(p.length>1?ASCompat.toString(p[1]):null);}
  function roomOptions():Vector<ExpandableDropdownOption>{var x:SharedGlobalPlaceholder  = null;var out=new Vector<ExpandableDropdownOption>();var seen:ASObject={};if(this._references!=null){final _iter_ = this._references.sharedPlaceholders; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_){x = _tmp_;
if(!seen[Std.string(x.roomId)]){seen[Std.string(x.roomId)]=true;out.push(new ExpandableDropdownOption(x.roomId,x.roomName));};
}}return out;}
  function onRoom(x:ExpandableDropdownOption){this.initPlaceholders(null);} function initPlaceholders(selected:String){var x:SharedGlobalPlaceholder  = null;var out=new Vector<ExpandableDropdownOption>();var idx=-1;var room=this._rooms.selectedId;if(this._references!=null){final _iter_ = this._references.sharedPlaceholders; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_){x = _tmp_;
if(x.roomId==room){if(x.placeholderName==selected)idx=out.length;out.push(new ExpandableDropdownOption(out.length,x.placeholderName));};
}}this._placeholders.reinit(out,idx);}
  override public function readIntParamsFromForm():Array<ASAny>{return [this._mode.selected,0,this._mode.selected==0?0:this._rooms.selectedId];}override public function readStringParamFromForm():String{return this._name.placeholderName+"\t"+(this._mode.selected==0?this._value.text:(this._placeholders.selected==null?"":this._placeholders.selected.displayString));}

	public function new() { super(); }
 }

