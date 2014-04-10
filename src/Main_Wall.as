package 
{
	import com.gestureworks.cml.core.*;
	import com.gestureworks.cml.elements.*;
	import com.gestureworks.cml.events.*;
	import com.gestureworks.cml.managers.*;
	import com.gestureworks.cml.utils.*;
	import com.gestureworks.core.*;
	import com.gestureworks.events.*;
	import com.gestureworks.utils.FrameRate;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	
	[SWF(width = "1920", height = "1080", backgroundColor = "0xcccccc", frameRate = "30")]
	
	/**
	 * Maxwell Database Collection Viewer
	 * @author Ideum
	 */
	public class Main_Wall extends GestureWorks
	{
		[Embed(source="/../lib/OpenSans-Light.ttf",fontName='OpenSansLight',fontFamily='OpenSans',fontWeight='light',fontStyle='normal',mimeType='application/x-font-truetype',advancedAntiAliasing='true',embedAsCFF='false',unicodeRange='U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E')]
		public static var OpenSansLight:Class;
		Font.registerFont(OpenSansLight);
		
		public function Main_Wall() 
		{
			super();	
			cml = "library/cml/CollectionViewer_Wall.cml";
			gml = "library/gml/my_gestures.gml";
			fullscreen = true;
		//	CMLParser.debug = true;
			CMLParser.instance.addEventListener(CMLParser.COMPLETE, cmlInit);
		}
		
		override protected function gestureworksInit():void
 		{
			trace("gestureWorksInit()");
		}
		
		private function cmlInit(event:Event):void
		{
			trace("cmlInit()");
		}
	
	}
}