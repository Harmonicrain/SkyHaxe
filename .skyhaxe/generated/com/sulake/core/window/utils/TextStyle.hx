package com.sulake.core.window.utils
;
     class TextStyle 
    {
        public static inline final NORMAL= "normal";
        public static inline final ITALIC= "italic";
        public static inline final BOLD= "bold";
        public static inline final UNDERLINE= "underline";
        public static inline final NONE= "none";
        public static inline final ADVANCED= "advanced";
        public static inline final TOP_LEFT= "top-left";
        public static inline final TOP= "top";
        public static inline final TOP_RIGHT= "top-right";
        public static inline final LEFT= "left";
        public static inline final RIGHT= "right";
        public static inline final BOTTOM_LEFT= "bottom-left";
        public static inline final BOTTOM= "bottom";
        public static inline final BOTTOM_RIGHT= "bottom-right";

        public var name:String;
        public var color:ASObject;
        public var fontFamily:String;
        public var fontSize:ASObject = null;
        public var fontStyle:String = null;
        public var fontWeight:String = null;
        public var kerning:ASObject = null;
        public var leading:ASObject = null;
        public var letterSpacing:ASObject = null;
        public var textDecoration:String = null;
        public var textIndent:ASObject = null;
        public var antiAliasType:String = null;
        public var sharpness:ASObject = null;
        public var thickness:ASObject = null;
        public var etchingColor:ASObject = null;
        public var etchingPosition:ASObject = null;


        public function toString():String
        {
            var k= "";
            k = (k + (this.name + " {\n"));
            if (this.color)
            {
                k = (k + (("\tcolor: #" + Std.string(this.color)) + ";\n"));
            }
            if (ASCompat.stringAsBool(this.fontFamily))
            {
                k = (k + (("\tfont-family: " + this.fontFamily) + ";\n"));
            }
            if (this.fontSize)
            {
                k = (k + (("\tfont-size: " + this.fontSize) + ";\n"));
            }
            if (ASCompat.stringAsBool(this.fontStyle))
            {
                k = (k + (("\tfont-style: " + this.fontStyle) + ";\n"));
            }
            if (ASCompat.stringAsBool(this.fontWeight))
            {
                k = (k + (("\tfont-weight: " + this.fontWeight) + ";\n"));
            }
            if (this.kerning)
            {
                k = (k + (("\tkerning: " + this.kerning) + ";\n"));
            }
            if (this.leading)
            {
                k = (k + (("\tleading: " + this.leading) + ";\n"));
            }
            if (this.letterSpacing)
            {
                k = (k + (("\tletter-spacing: " + this.letterSpacing) + ";\n"));
            }
            if (ASCompat.stringAsBool(this.textDecoration))
            {
                k = (k + (("\ttext-decoration: " + this.textDecoration) + ";\n"));
            }
            if (this.textIndent)
            {
                k = (k + (("\ttext-indent: " + this.textIndent) + ";\n"));
            }
            if (ASCompat.stringAsBool(this.antiAliasType))
            {
                k = (k + (("\tanti-alias-type: " + this.antiAliasType) + ";\n"));
            }
            if (this.sharpness)
            {
                k = (k + (("\tsharpness: " + this.sharpness) + ";\n"));
            }
            if (this.thickness)
            {
                k = (k + (("\tthickness: " + this.thickness) + ";\n"));
            }
            if (this.etchingColor)
            {
                k = (k + (("\tetching-color: #" + Std.string(this.etchingColor)) + ";\n"));
            }
            if (this.etchingPosition)
            {
                k = (k + (("\tetching-direction: " + this.etchingPosition) + ";\n"));
            }
            k = (k + "}");
            return k;
        }

        public function equals(k:TextStyle):Bool
        {
            return ((((((((((((((this.color == k.color) && (this.fontFamily == k.fontFamily)) && (this.fontSize == k.fontSize)) && (this.fontStyle == k.fontStyle)) && (this.fontWeight == k.fontWeight)) && (this.kerning == k.kerning)) && (this.leading == k.leading)) && (this.letterSpacing == k.letterSpacing)) && (this.textDecoration == k.textDecoration)) && (this.textIndent == k.textIndent)) && (this.antiAliasType == k.antiAliasType)) && (this.sharpness == k.sharpness)) && (this.thickness == k.thickness)) && (this.etchingColor == k.etchingColor)) && (this.etchingPosition == k.etchingPosition);
        }

        public function clone():TextStyle
        {
            var k= new TextStyle();
            k.name = this.name;
            k.color = this.color;
            k.fontFamily = this.fontFamily;
            k.fontSize = this.fontSize;
            k.fontStyle = this.fontStyle;
            k.fontWeight = this.fontWeight;
            k.kerning = this.kerning;
            k.leading = this.leading;
            k.letterSpacing = this.letterSpacing;
            k.textDecoration = this.textDecoration;
            k.textIndent = this.textIndent;
            k.antiAliasType = this.antiAliasType;
            k.sharpness = this.sharpness;
            k.thickness = this.thickness;
            k.etchingColor = this.etchingColor;
            k.etchingPosition = this.etchingPosition;
            return k;
        }
public function new(){}
    }

