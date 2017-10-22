package loading;
import jammer.engines.display.types.JamFlashShape;
import jammer.utils.MathUtils;

/**
 * ...
 * @author Pierre Chabiland
 */
class Gauge extends JamFlashShape
{

	public var width:Int;
	public var height:Int;
	public var padding:Int;
	public var bgColor:Int;
	public var barColor:Int;
	public var barTopColor:Int;
	public var barTopHeight:Int;
	
	public function new() 
	{
		super();
		width = 128;
		height = 16;
		padding = 2;
		barTopHeight = 2;
		
		bgColor = 0x1b191b;
		barColor = 0xb61814;
		barTopColor = 0xb64b49;
		
	}
	
	
	public function progress(pValue:Float,pTotal:Float):Void{
		graphics.clear();
		var rate = pValue / pTotal;
		var barW:Int = MathUtils.round(rate * (width - padding*2));
		graphics.beginFill(bgColor, 1);
		graphics.drawRect(0, 0, width, height);
		graphics.endFill();
		
		graphics.beginFill(barColor, 1);
		graphics.drawRect(padding, padding, barW, height-padding*2);
		graphics.endFill();
		if(barTopHeight>0){
			graphics.beginFill(barTopColor, 1);
			graphics.drawRect(padding, padding, barW, barTopHeight);
			graphics.endFill();
		}
	}
}