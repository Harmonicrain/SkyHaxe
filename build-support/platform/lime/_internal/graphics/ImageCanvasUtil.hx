package lime._internal.graphics;

// SkyHaxe override of Lime 8.3.2's ImageCanvasUtil (build-support/platform). Two changes:
// willReadFrequently on the canvases Lime creates for BitmapData (see createCanvas), and the
// uniform-canvas shortcut that answers readbacks of blank or solidly filled canvases without
// getImageData (see markUniform).

import haxe.format.JsonParser;
import haxe.io.Bytes;
import lime.graphics.Image;
import lime.graphics.ImageBuffer;
import lime.graphics.ImageChannel;
import lime.graphics.PixelFormat;
import lime.math.ColorMatrix;
import lime.math.Rectangle;
import lime.math.Vector2;
import lime.system.Endian;
import lime.utils.BytePointer;
import lime.utils.UInt8Array;
#if (js && html5)
import js.Browser;
#end

@:access(lime.graphics.ImageBuffer)
// Pinned to the Lime 8.3.2 original: the build fails if it changes, so this copy cannot mask an upgrade.
@:build(skyhaxe.GeneratedPin.check(".haxelib/lime/8,3,2/src/lime/_internal/graphics/ImageCanvasUtil.hx",
	"7fe03d1eddc0d5bb1406f1ba0856127092a4d5af116aef30b4e43a829bb64299"))
class ImageCanvasUtil
{
	public static function colorTransform(image:Image, rect:Rectangle, colorMatrix:ColorMatrix):Void
	{
		convertToData(image);

		ImageDataUtil.colorTransform(image, rect, colorMatrix);
	}

	public static function convertToCanvas(image:Image, clear:Bool = false):Void
	{
		#if (js && html5)
		var buffer = image.buffer;

		if (buffer.__srcImage != null)
		{
			if (buffer.__srcCanvas == null)
			{
				createCanvas(image, buffer.__srcImage.width, buffer.__srcImage.height);
				buffer.__srcContext.drawImage(buffer.__srcImage, 0, 0);
				clearUniform(image);
			}

			buffer.__srcImage = null;
		}
		else if (buffer.__srcCanvas == null && buffer.data != null)
		{
			image.transparent = true;
			createCanvas(image, buffer.width, buffer.height);
			clearUniform(image);
			createImageData(image);

			buffer.__srcContext.putImageData(buffer.__srcImageData, 0, 0);
		}
		else
		{
			if (image.type == DATA && buffer.__srcImageData != null && image.dirty)
			{
				buffer.__srcContext.putImageData(buffer.__srcImageData, 0, 0);
				clearUniform(image);
				image.dirty = false;
			}
		}

		if (clear)
		{
			buffer.data = null;
			buffer.__srcImageData = null;
		}
		else
		{
			if (buffer.data == null && buffer.__srcImageData != null)
			{
				buffer.data = cast buffer.__srcImageData.data;
			}
		}
		#end

		image.type = CANVAS;
	}

	public static function convertToData(image:Image, clear:Bool = false):Void
	{
		var buffer = image.buffer;

		#if (js && html5)
		if (buffer.__srcImage != null)
		{
			convertToCanvas(image);
		}

		if (buffer.__srcCanvas != null && buffer.data == null)
		{
			createImageData(image);
			if (image.type == CANVAS) image.dirty = false;
		}
		else if (image.type == CANVAS && buffer.__srcCanvas != null && image.dirty)
		{
			if (buffer.__srcImageData == null)
			{
				createImageData(image);
			}
			else
			{
				var uniform = uniformImageData(image);
				buffer.__srcImageData = uniform != null ? uniform : buffer.__srcContext.getImageData(0, 0, buffer.width, buffer.height);
				buffer.data = new UInt8Array(cast buffer.__srcImageData.data.buffer);
			}

			image.dirty = false;
		}

		if (clear)
		{
			image.buffer.__srcCanvas = null;
			image.buffer.__srcContext = null;
		}
		#end

		image.type = DATA;
	}

	public static function copyChannel(image:Image, sourceImage:Image, sourceRect:Rectangle, destPoint:Vector2, sourceChannel:ImageChannel,
			destChannel:ImageChannel):Void
	{
		convertToData(sourceImage);
		convertToData(image);

		ImageDataUtil.copyChannel(image, sourceImage, sourceRect, destPoint, sourceChannel, destChannel);
	}

	public static function copyPixels(image:Image, sourceImage:Image, sourceRect:Rectangle, destPoint:Vector2, alphaImage:Image = null,
			alphaPoint:Vector2 = null, mergeAlpha:Bool = false):Void
	{
		if (destPoint == null || destPoint.x >= image.width || destPoint.y >= image.height || sourceRect == null || sourceRect.width < 1
			|| sourceRect.height < 1)
		{
			return;
		}

		if (alphaImage != null && alphaImage.transparent)
		{
			if (alphaPoint == null) alphaPoint = new Vector2();

			// TODO: use faster method

			var tempData = sourceImage.clone();
			tempData.copyChannel(alphaImage, new Rectangle(sourceRect.x + alphaPoint.x, sourceRect.y + alphaPoint.y, sourceRect.width, sourceRect.height),
				new Vector2(sourceRect.x, sourceRect.y), ImageChannel.ALPHA, ImageChannel.ALPHA);
			sourceImage = tempData;
		}

		convertToCanvas(image, true);

		if (!mergeAlpha)
		{
			if (image.transparent && sourceImage.transparent)
			{
				image.buffer.__srcContext.clearRect(destPoint.x
					+ image.offsetX, destPoint.y
					+ image.offsetY, sourceRect.width
					+ image.offsetX,
					sourceRect.height
					+ image.offsetY);
			}
		}

		convertToCanvas(sourceImage);

		if (sourceImage.buffer.src != null)
		{
			// Set default composition (just in case it is different)
			image.buffer.__srcContext.globalCompositeOperation = "source-over";

			image.buffer.__srcContext.drawImage(sourceImage.buffer.src, Std.int(sourceRect.x + sourceImage.offsetX),
				Std.int(sourceRect.y + sourceImage.offsetY), Std.int(sourceRect.width), Std.int(sourceRect.height), Std.int(destPoint.x + image.offsetX),
				Std.int(destPoint.y + image.offsetY), Std.int(sourceRect.width), Std.int(sourceRect.height));
		}

		image.dirty = true;
		image.version++;
	}

	public static function createCanvas(image:Image, width:Int, height:Int):Void
	{
		#if (js && html5)
		var buffer = image.buffer;

		if (buffer.__srcCanvas == null)
		{
			buffer.__srcCanvas = cast Browser.document.createElement("canvas");
			buffer.__srcCanvas.width = width;
			buffer.__srcCanvas.height = height;

			if (!image.transparent)
			{
				buffer.__srcCanvas.setAttribute("moz-opaque", "true");
			}

			// SkyHaxe: BitmapData canvases are read back constantly (colorTransform, getPixels,
			// getVector, hit tests). Without willReadFrequently each readback is a GPU->CPU
			// getImageData stall -- ~1.9 s of a cold boot into a room. CPU-backed canvases make
			// those reads cheap; the stage itself renders through WebGL, not these canvases.
			buffer.__srcContext = buffer.__srcCanvas.getContext("2d", {alpha: image.transparent, willReadFrequently: true});
			// Blank: transparent black, or opaque black for an alpha:false context. Callers that
			// then draw or put pixels without bumping image.version clear this again.
			markUniform(image, 0, 0, 0, image.transparent ? 0 : 0xFF);
		}
		#end
	}

	#if (js && html5)
	/**
		SkyHaxe: the uniform-canvas shortcut. Many BitmapData canvases are only ever blank or filled
		with one solid colour before their first pixel read (new BitmapData(w, h, true, c),
		fillRect(rect, c) to clear a reused plane, the white base of a coloured plane layer), yet
		Lime's convertToData reads them back with getImageData -- ~0.5 s of room entry. When the
		whole canvas is known to hold one colour, the ImageData is synthesised instead.

		The record is the colour plus the image.version it was taken at: every Lime and OpenFL
		path that changes canvas pixels bumps image.version (fillRect, copyPixels, draw,
		HabboText, setPixels...), and the three that do not (the two putImageData/drawImage syncs
		in convertToCanvas, and the transparent full clear in fillRect) clear or set it explicitly.
		Only alpha 0 and 255 are recorded: the canvas returns those exactly, whereas a
		semi-transparent fill comes back through premultiplied rounding.
	**/
	static var __uniformLittleEndian:Null<Bool>;

	static function markUniform(image:Image, r:Int, g:Int, b:Int, a:Int):Void
	{
		var buffer:Dynamic = image.buffer;
		if (image.offsetX == 0 && image.offsetY == 0 && image.width == image.buffer.width && image.height == image.buffer.height
			&& (a == 0 || a == 0xFF))
		{
			buffer.__skyUniformImage = image;
			buffer.__skyUniformVersion = image.version;
			buffer.__skyUniformRGBA = a == 0 ? 0 : (r | (g << 8) | (b << 16) | (a << 24));
		}
		else
		{
			buffer.__skyUniformImage = null;
		}
	}

	static inline function clearUniform(image:Image):Void
	{
		var buffer:Dynamic = image.buffer;
		buffer.__skyUniformImage = null;
	}

	static function uniformImageData(image:Image):Dynamic
	{
		var buffer:Dynamic = image.buffer;
		if (buffer.__skyUniformImage != image || buffer.__skyUniformVersion != image.version || buffer.__srcContext == null) return null;
		if (__uniformLittleEndian == null)
		{
			__uniformLittleEndian = new js.lib.Uint8Array(new js.lib.Uint32Array([1]).buffer)[0] == 1;
		}
		if (!__uniformLittleEndian) return null;
		var imageData:Dynamic = buffer.__srcContext.createImageData(image.buffer.width, image.buffer.height);
		var packed:Int = buffer.__skyUniformRGBA;
		if (packed != 0) (new js.lib.Uint32Array(imageData.data.buffer)).fill(packed);
		return imageData;
	}
	#end

	public static function createImageData(image:Image):Void
	{
		#if (js && html5)
		var buffer = image.buffer;

		if (buffer.__srcImageData == null)
		{
			if (buffer.data == null)
			{
				var uniform = uniformImageData(image);
				buffer.__srcImageData = uniform != null ? uniform : buffer.__srcContext.getImageData(0, 0, buffer.width, buffer.height);
			}
			else
			{
				buffer.__srcImageData = buffer.__srcContext.createImageData(buffer.width, buffer.height);
				buffer.__srcImageData.data.set(cast buffer.data);
			}

			buffer.data = new UInt8Array(cast buffer.__srcImageData.data.buffer);
		}
		#end
	}

	public static function fillRect(image:Image, rect:Rectangle, color:Int, format:PixelFormat):Void
	{
		convertToCanvas(image);

		var r:Int;
		var g:Int;
		var b:Int;
		var a:Int;

		if (format == ARGB32)
		{
			r = (color >> 16) & 0xFF;
			g = (color >> 8) & 0xFF;
			b = color & 0xFF;
			a = (image.transparent) ? (color >> 24) & 0xFF : 0xFF;
		}
		else
		{
			r = (color >> 24) & 0xFF;
			g = (color >> 16) & 0xFF;
			b = (color >> 8) & 0xFF;
			a = (image.transparent) ? color & 0xFF : 0xFF;
		}

		if (rect.x == 0 && rect.y == 0 && rect.width == image.width && rect.height == image.height)
		{
			if (image.transparent && a == 0)
			{
				image.buffer.__srcCanvas.width = image.buffer.width;
				markUniform(image, 0, 0, 0, 0);
				return;
			}
		}

		if (a < 255)
		{
			image.buffer.__srcContext.clearRect(rect.x + image.offsetX, rect.y + image.offsetY, rect.width + image.offsetX, rect.height + image.offsetY);
		}

		if (a > 0)
		{
			image.buffer.__srcContext.fillStyle = 'rgba(' + r + ', ' + g + ', ' + b + ', ' + (a / 255) + ')';
			image.buffer.__srcContext.fillRect(rect.x + image.offsetX, rect.y + image.offsetY, rect.width + image.offsetX, rect.height + image.offsetY);
		}

		image.dirty = true;
		image.version++;

		#if (js && html5)
		if (rect.x == 0 && rect.y == 0 && rect.width == image.width && rect.height == image.height && (a == 0 || a == 0xFF))
		{
			// An opaque context stores every fill as opaque.
			markUniform(image, r, g, b, image.transparent ? a : 0xFF);
		}
		#end
	}

	public static function floodFill(image:Image, x:Int, y:Int, color:Int, format:PixelFormat):Void
	{
		convertToData(image);

		ImageDataUtil.floodFill(image, x, y, color, format);
	}

	public static function getPixel(image:Image, x:Int, y:Int, format:PixelFormat):Int
	{
		convertToData(image);

		return ImageDataUtil.getPixel(image, x, y, format);
	}

	public static function getPixel32(image:Image, x:Int, y:Int, format:PixelFormat):Int
	{
		convertToData(image);

		return ImageDataUtil.getPixel32(image, x, y, format);
	}

	public static function getPixels(image:Image, rect:Rectangle, format:PixelFormat):Bytes
	{
		convertToData(image);

		return ImageDataUtil.getPixels(image, rect, format);
	}

	public static function merge(image:Image, sourceImage:Image, sourceRect:Rectangle, destPoint:Vector2, redMultiplier:Int, greenMultiplier:Int,
			blueMultiplier:Int, alphaMultiplier:Int):Void
	{
		convertToData(sourceImage);
		convertToData(image);

		ImageDataUtil.merge(image, sourceImage, sourceRect, destPoint, redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier);
	}

	public static function resize(image:Image, newWidth:Int, newHeight:Int):Void
	{
		var buffer = image.buffer;

		if (buffer.__srcCanvas == null)
		{
			createCanvas(image, newWidth, newHeight);
			buffer.__srcContext.drawImage(buffer.src, 0, 0, newWidth, newHeight);
		}
		else
		{
			convertToCanvas(image, true);
			var sourceCanvas = buffer.__srcCanvas;
			buffer.__srcCanvas = null;
			createCanvas(image, newWidth, newHeight);
			buffer.__srcContext.drawImage(sourceCanvas, 0, 0, newWidth, newHeight);
		}

		buffer.__srcImageData = null;
		buffer.data = null;

		image.dirty = true;
		image.version++;
	}

	public static function scroll(image:Image, x:Int, y:Int):Void
	{
		if ((x % image.width == 0) && (y % image.height == 0)) return;

		var copy = image.clone();

		convertToCanvas(image, true);

		image.buffer.__srcContext.clearRect(x, y, image.width, image.height);
		image.buffer.__srcContext.drawImage(copy.src, x, y);

		image.dirty = true;
		image.version++;
	}

	public static function setPixel(image:Image, x:Int, y:Int, color:Int, format:PixelFormat):Void
	{
		convertToData(image);

		ImageDataUtil.setPixel(image, x, y, color, format);
	}

	public static function setPixel32(image:Image, x:Int, y:Int, color:Int, format:PixelFormat):Void
	{
		convertToData(image);

		ImageDataUtil.setPixel32(image, x, y, color, format);
	}

	public static function setPixels(image:Image, rect:Rectangle, bytePointer:BytePointer, format:PixelFormat, endian:Endian):Void
	{
		convertToData(image);

		ImageDataUtil.setPixels(image, rect, bytePointer, format, endian);
	}

	public static function sync(image:Image, clear:Bool):Void
	{
		if (image == null) return;

		#if (js && html5)
		if (image.type == CANVAS && (image.buffer.__srcCanvas != null || image.buffer.data != null))
		{
			convertToCanvas(image, clear);
		}
		else if (image.type == DATA)
		{
			convertToData(image, clear);
		}
		#end
	}
}
