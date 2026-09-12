package com.sulake.habbo.roomevents.wired_setup.actiontypes
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.NumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.NamedTextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.RewardListPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.RewardRowPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class GiveRewardActionElement extends DefaultElement
    {
        static inline final MAX_REWARDS= 20;
        static inline final DEFAULT_REWARDS= 5;

        var _prizeLimitCheckbox:CheckboxGroupPreset;
        var _prizeLimitInput:NumberInputPreset;
        var _prizeLimitWarning:TextPreset;
        var _prizeLimitWarningHeight:Int = 0;
        var _rewardIntervalGroup:RadioGroupPreset;
        var _rewardIntervalInput:NamedTextInputPreset;
        var _uniquePrizeCheckbox:CheckboxGroupPreset;
        var _rewardList:RewardListPreset;
        var _displayedRewards:Int = DEFAULT_REWARDS;

        override public function  get_code():Int
        {
            return ActionTypeCodes.GIVE_REWARD;
        }

        override public function  get_inputMode():Int
        {
            return DefaultElement.INPUTS_TYPE_UI_BUILDER;
        }

        override public function buildInputs(manager:PresetManager,
                                             style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            this._prizeLimitInput = manager.createNumberInput(
                new NumberInputParam(1, 1, 1000, 60));
            var prizeLimitOption= new CheckboxOptionParam(
                roomEvents.localization.getLocalizationWithParams(
                    "wiredfurni.params.prizelimit", "", ["amount", ""]), 0);
            prizeLimitOption.extra1 = this._prizeLimitInput;
            this._prizeLimitCheckbox = manager.createCheckboxGroup(
                [prizeLimitOption], this.onPrizeLimitToggle);
            var warningParam= new TextParam(TextParam.MODE_MULTILINE, false);
            warningParam.textColor = 13369344;
            this._prizeLimitWarning = manager.createText(
                "Reward limit not set. Make sure rewards are badges or non-tradeable items.",
                warningParam);
            this._prizeLimitWarningHeight = this._prizeLimitWarning.window.height;
            var prizeLimitList= manager.createSimpleListView(
                true, [this._prizeLimitCheckbox, this._prizeLimitWarning]);
            var prizeLimitSection= manager.createSection(
                "Reward limit", prizeLimitList);

            this._rewardIntervalGroup = manager.createRadioGroup([
                new RadioButtonParam(0, "Once"),
                new RadioButtonParam(1, "1 / n Days"),
                new RadioButtonParam(2, "1 / n Hours"),
                new RadioButtonParam(3, "1 / n Mins")
            ], this.onRewardIntervalChange, 2);
            this._rewardIntervalInput = manager.createNamedTextInput(
                new TextInputParam("1", 4, null, 60, "0-9"), "n =");
            var intervalList= manager.createSimpleListView(
                true, [this._rewardIntervalGroup, this._rewardIntervalInput]);
            var intervalSection= manager.createSection(
                "How often can a user be rewarded", intervalList);

            var uniqueOption= new CheckboxOptionParam(
                "Unique Rewards?", 0);
            uniqueOption.extra2 = manager.createText(
                "If checked each reward will be given once to each user. Probabilities are not in use.",
                new TextParam(TextParam.MODE_MULTILINE, false));
            this._uniquePrizeCheckbox = manager.createCheckboxGroup(
                [uniqueOption], this.onUniquePrizeToggle);
            var uniqueSection= manager.createSection(
                "Unique Rewards", this._uniquePrizeCheckbox);

            this._rewardList = manager.createRewardList(
                MAX_REWARDS, this._displayedRewards);
            var addRewardButton=
                manager.createTextualButtonPreset("Add reward", this.onAddReward);
            var rewardsParam= new SectionParam();
            rewardsParam.addHeaderOption(addRewardButton);
            var rewardsSection= manager.createSection(
                "Rewards", this._rewardList, rewardsParam);

            builder.addElements([prizeLimitSection, intervalSection,
                uniqueSection, rewardsSection]);
            this.updatePrizeLimitState();
            this.onRewardIntervalChange(this._rewardIntervalGroup.selected);
        }

        override public function onEditStart(data:Triggerable)
        {
var row:RewardRowPreset  = null;            var intData= data.intData != null ? data.intData : [];
            this._rewardIntervalGroup.selected =
                intData.length > 0 ? ASCompat.toInt(intData[0]) : 0;
            this._rewardIntervalInput.text =
                this._rewardIntervalGroup.selected > 0 && intData.length == 4
                    ? ASCompat.toString(intData[3]) : "1";
            this.onRewardIntervalChange(this._rewardIntervalGroup.selected);

            var unique= intData.length > 1 && ASCompat.toInt(intData[1]) == 1;
            this._uniquePrizeCheckbox.get(0).selected = unique;
            this.setProbabilityEnabled(!unique);

            var limit= intData.length > 2 ? ASCompat.toInt(intData[2]) : 0;
            if (limit > 0)
            {
                this._prizeLimitInput.value = limit;
                this._prizeLimitCheckbox.get(0).selected = true;
            }
            else
            {
                this._prizeLimitCheckbox.get(0).selected = false;
            }
            this.updatePrizeLimitState();

            this._displayedRewards = DEFAULT_REWARDS;
            var rewards:Array<ASAny> = data.stringData == null || data.stringData == ""
                ? [] : (cast data.stringData.split(";"));
            var index = 0;
            while (index < MAX_REWARDS)
            {
row= this._rewardList.getRow(index);
                if (rewards[index])
                {
                    this.setRewardData(row, rewards[index]);
                    this._displayedRewards = Std.int(Math.max(
                        this._displayedRewards, index + 1));
                }
                else
                {
                    row.clear();
                }
                index++;
            }
            this._rewardList.setDisplayedRewards(this._displayedRewards);
        }

        override public function validate():String
        {
var row:RewardRowPreset  = null, error:String  = null;            var totalProbability = 0;
            var unique= this._uniquePrizeCheckbox.get(0).selected;
            var index = 0;
            while (index < this._rewardList.displayedRewards)
            {
row= this._rewardList.getRow(index);
error= this.validateReward(row, unique);
                if (error != null)
                {
                    return error;
                }
                if (!unique && row.probabilityText != "")
                {
                    totalProbability += ASCompat.toInt(row.probabilityText);
                }
                index++;
            }
            if (totalProbability > 100)
            {
                return "The sum of probabilities cannot exceed 100. You now have " +
                    Std.string(totalProbability) + ".";
            }
            return null;
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            var interval= ASCompat.toInt(this._rewardIntervalInput.text);
            return [
                this._rewardIntervalGroup.selected,
                this._uniquePrizeCheckbox.get(0).selected ? 1 : 0,
                this._prizeLimitCheckbox.get(0).selected
                    ? this._prizeLimitInput.value : 0,
                interval >= 1 ? interval : 1
            ];
        }

        override public function readStringParamFromForm():String
        {
var reward:String  = null;            var result= "";
            var index = 0;
            while (index < this._rewardList.displayedRewards)
            {
reward= this.getRewardData(
                    this._rewardList.getRow(index));
                if (reward != null)
                {
                    result += (result == "" ? "" : ";") + reward;
                }
                index++;
            }
            return result;
        }

        function onPrizeLimitToggle(index:Int, selected:Bool)
        {
            if (index == 0)
            {
                this.updatePrizeLimitState();
            }
        }

        function updatePrizeLimitState()
        {
            var selected= this._prizeLimitCheckbox.get(0).selected;
            this._prizeLimitWarning.visible = !selected;
            this._prizeLimitWarning.window.height =
                selected ? 0 : this._prizeLimitWarningHeight;
        }

        function onUniquePrizeToggle(index:Int, selected:Bool)
        {
            if (index == 0)
            {
                this.setProbabilityEnabled(!selected);
            }
        }

        function setProbabilityEnabled(value:Bool)
        {
            this._rewardList.setProbabilityEnabled(value);
        }

        function onAddReward()
        {
            this._displayedRewards = Std.int(Math.min(
                MAX_REWARDS, this._displayedRewards + 1));
            this._rewardList.setDisplayedRewards(this._displayedRewards);
        }

        function onRewardIntervalChange(value:Int)
        {
            this._rewardIntervalInput.disabled = value == 0;
        }

        function validateReward(row:RewardRowPreset,
                                        unique:Bool):String
        {
var probabilityValue = 0;            var codeValue= row.code;
            var probability= row.probabilityText;
            if (codeValue == "" && probability == "")
            {
                return null;
            }
            if (codeValue.indexOf(",") > 0)
            {
                return "Product/badge codes must not contain ',' characters.";
            }
            if (codeValue.indexOf(";") > 0)
            {
                return "Product/badge codes must not contain ';' characters.";
            }
            if (codeValue.length > 100)
            {
                return "Product/badge codes cannot contain more than 100 characters.";
            }
            if (codeValue == "")
            {
                return "Remember to define product/badge codes for all rewards (fill all fields or leave all fields empty).";
            }
            if (!unique)
            {
                if (probability == "")
                {
                    return "Remember to define probabilities for all rewards (fill all fields or leave all fields empty).";
                }
                if (Math.isNaN(ASCompat.toNumber(probability)))
                {
                    return "Make sure are probabilities are numbers.";
                }
probabilityValue= ASCompat.toInt(probability);
                if (probabilityValue < 1 || probabilityValue > 100)
                {
                    return "Make sure all probabilities are numbers between 1 and 100.";
                }
            }
            return null;
        }

        function getRewardData(row:RewardRowPreset):String
        {
            var codeValue= this.replaceAll(row.code, ";", "");
            codeValue = this.replaceAll(codeValue, ",", "");
            if (codeValue == "")
            {
                return null;
            }
            var probability= Math.isNaN(ASCompat.toNumber(row.probabilityText))
                ? 0 : ASCompat.toInt(row.probabilityText);
            return (row.isBadge ? "0" : "1") + "," + codeValue + "," +
                Std.string(probability);
        }

        function setRewardData(row:RewardRowPreset, data:String)
        {
            var parts:Array<ASAny> = data == null ? [] : (cast data.split(","));
            row.code = parts[1] ? parts[1] : "";
            row.probabilityText = parts[2] ? parts[2] : "";
            row.isBadge = ASCompat.toBool(parts[0]) && parts[0] == "0";
        }

        function replaceAll(value:String,
                                    search:String,
                                    replacement:String):String
        {
            var remaining= 100;
            while (value.indexOf(search) > -1)
            {
                value = ASCompat.stringReplace(value, search, replacement);
                if (--remaining < 1)
                {
                    break;
                }
            }
            return value;
        }

	public function new() { super(); }
    }

