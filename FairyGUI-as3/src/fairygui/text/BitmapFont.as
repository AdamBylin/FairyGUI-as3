package fairygui.text
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class BitmapFont
	{
		public var id:String;
		public var size:int;
		public var ttf:Boolean;
		public var resizable:Boolean;
		public var colored:Boolean;
		public var atlas:BitmapData;		
		public var glyphs:Object;
		
		public function BitmapFont()
		{
			glyphs = {};
		}

		public function dispose():void
		{
			if(atlas!=null)
				atlas.dispose();
		}
		
		public function translateChannel(channel:int):int
		{
			switch(channel)
			{
				case 1:
					return BitmapDataChannel.BLUE;
				case 2:
					return BitmapDataChannel.GREEN;
				case 4:
					return BitmapDataChannel.RED;
				case 8:
					return BitmapDataChannel.ALPHA;
				default:
					return BitmapDataChannel.ALPHA;
			}
		}
		
		private static var sHelperPoint:Point = new Point();
		private static var sHelperRect:Rectangle = new Rectangle();
		private static var sTransform:ColorTransform = new ColorTransform(0,0,0,1);
		private static var sHelperMat:Matrix = new Matrix();
		private static var sHelperBmd:BitmapData = new BitmapData(200,200,true,0);
		
		public function draw(target:BitmapData, glyph:BMGlyph, charPosX:Number, charPosY:Number, color:uint, fontScale:Number):void
		{
			charPosX += Math.ceil(glyph.offsetX*fontScale);
			
			if(ttf)
			{
				if(atlas!=null)
				{
					sHelperBmd.fillRect(sHelperBmd.rect, 0);
					
					sHelperRect.x = 0;
					sHelperRect.y = 0;
					sHelperRect.width = glyph.width;
					sHelperRect.height = glyph.height;
					sHelperBmd.fillRect(sHelperRect, 0xFF000000 + color);
					
					sHelperRect.x = glyph.x;
					sHelperRect.y = glyph.y;
					sHelperBmd.copyChannel(atlas, sHelperRect, sHelperPoint, glyph.channel, BitmapDataChannel.ALPHA);
					
					sHelperMat.identity();
					sHelperMat.scale(fontScale, fontScale);
					sHelperMat.translate(charPosX, charPosY);
					sHelperRect.x = charPosX;
					sHelperRect.y = charPosY;
					sHelperRect.width = Math.ceil(glyph.width*fontScale);
					sHelperRect.height = Math.ceil(glyph.height*fontScale);
					target.draw(sHelperBmd, sHelperMat, null, null, sHelperRect, true);
				}
			}
			else if(glyph.imageItem!=null)
			{
				var bmd:BitmapData = glyph.imageItem.image;
				if(bmd!=null)
				{
					sHelperMat.identity();
					sHelperMat.scale(fontScale, fontScale);
					sHelperMat.translate(charPosX, charPosY);
					if(colored)
					{
						sTransform.color = color;
						target.draw(bmd, sHelperMat, sTransform, null, null, true);
					}
					else
						target.draw(bmd, sHelperMat, null, null, null, true);
				}
			}
		}
	}
}


