package jammer.algo;

import haxe.Constraints.Function;
import jammer.utils.MathUtils;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class Bresenham
{
    public static var me : Bresenham = new Bresenham();
    public function new()
    {
    }

    public inline static function getThinLine(x0 : Int, y0 : Int, x1 : Int, y1 : Int) : Array<Dynamic>
    {
        var pts : Array<Dynamic> = [];
        var swapXY : Bool = MathUtils.iabs(y1 - y0) > MathUtils.iabs(x1 - x0);
        var tmp : Int;
        if (swapXY)
        {
            // swap x and y
            tmp = x0;x0 = y0;y0 = tmp;  // swap x0 and y0  
            tmp = x1;x1 = y1;y1 = tmp;
        }
        if (x0 > x1)
        {
            // make sure x0 < x1
            tmp = x0;x0 = x1;x1 = tmp;  // swap x0 and x1  
            tmp = y0;y0 = y1;y1 = tmp;
        }
        var deltax : Int = Std.int(x1 - x0);
        var deltay : Int = MathUtils.floor(MathUtils.iabs(y1 - y0));
        var error : Int = MathUtils.floor(deltax / 2);
        var y : Int = y0;
        var x : Int;
        var ystep : Int = ((y0 < y1)) ? 1 : -1;
        if (swapXY)
        {
            // Y / X
            for (x in x0...x1 + 1)
            {
                pts.push({
                            x : y,
                            y : x
                        });
                error -= deltay;
                if (error < 0)
                {
                    y += ystep;
                    error = Std.int(error + deltax);
                }
            }
        }
        else
        {
            // X / Y
            for (x in x0...x1 + 1)
            {
                pts.push({
                            x : x,
                            y : y
                        });
                error -= deltay;
                if (error < 0)
                {
                    y += ystep;
                    error = Std.int(error + deltax);
                }
            }
        }
        return pts;
    }
    
    public inline static function getFatLine(x0 : Int, y0 : Int, x1 : Int, y1 : Int) : Array<Dynamic>
    {
        var pts : Array<Dynamic> = [];
        var swapXY : Bool = MathUtils.iabs(y1 - y0) > MathUtils.iabs(x1 - x0);
        var tmp : Int;
        if (swapXY)
        {
            // swap x and y
            tmp = x0;x0 = y0;y0 = tmp;  // swap x0 and y0  
            tmp = x1;x1 = y1;y1 = tmp;
        }
        if (x0 > x1)
        {
            // make sure x0 < x1
            tmp = x0;x0 = x1;x1 = tmp;  // swap x0 and x1  
            tmp = y0;y0 = y1;y1 = tmp;
        }
        var deltax : Int = Std.int(x1 - x0);
        var deltay : Int = MathUtils.floor(MathUtils.iabs(y1 - y0));
        var error : Int = MathUtils.floor(deltax / 2);
        var y : Int = y0;
        var x : Int;
        var ystep : Int = ((y0 < y1)) ? 1 : -1;
        
        if (swapXY)
        {
            // Y / X
            for (x in x0...x1 + 1)
            {
                pts.push({
                            x : y,
                            y : x
                        });
                
                error -= deltay;
                if (error < 0)
                {
                    if (x < x1)
                    {
                        pts.push({
                                    x : y + ystep,
                                    y : x
                                });
                        pts.push({
                                    x : y,
                                    y : x + 1
                                });
                    }
                    y += ystep;
                    error = Std.int(error + deltax);
                }
            }
        }
        else
        {
            // X / Y
            for (x in x0...x1 + 1)
            {
                pts.push({
                            x : x,
                            y : y
                        });
                
                error -= deltay;
                if (error < 0)
                {
                    if (x < x1)
                    {
                        pts.push({
                                    x : x,
                                    y : y + ystep
                                });
                        pts.push({
                                    x : x + 1,
                                    y : y
                                });
                    }
                    y += ystep;
                    error = Std.int(error + deltax);
                }
            }
        }
        return pts;
    }
    
    // Donne la liste des points situés sur un cercle donné
    // Source : http://en.wikipedia.org/wiki/Midpoint_circle_algorithm

    public inline static function getCircle(x0 : Int, y0 : Int, radius : Int) : Array<Dynamic>
    {
        var pts : Array<Dynamic> = [];
        var x : Int = radius;
        var y : Int = 0;
        var radiusError : Int = Std.int(1 - x);
        while (x >= y)
        {
            pts.push({
                        x : x + x0,
                        y : y + y0
                    });
            pts.push({
                        x : -x + x0,
                        y : y + y0
                    });
            
            pts.push({
                        x : y + x0,
                        y : x + y0
                    });
            pts.push({
                        x : -y + x0,
                        y : x + y0
                    });
            
            pts.push({
                        x : x + x0,
                        y : -y + y0
                    });
            pts.push({
                        x : -x + x0,
                        y : -y + y0
                    });
            
            pts.push({
                        x : y + x0,
                        y : -x + y0
                    });
            pts.push({
                        x : -y + x0,
                        y : -x + y0
                    });
            
            y++;
            if (radiusError < 0)
            {
                radiusError += 2 * y + 1;
            }
            else
            {
                x--;
                radiusError += 2 * (y - x + 1);
            }
        }
        return pts;
    }

    public inline static function checkThinLine(x0 : Int, y0 : Int, x1 : Int, y1 : Int, rayCanPass : Int->Int->Bool) : Bool
    {
        if (!rayCanPass(x0, y0))
        {
            return false;
        }
        
        if (!rayCanPass(x1, y1))
        {
            return false;
        }
        
        var swapXY : Bool = MathUtils.iabs(y1 - y0) > MathUtils.iabs(x1 - x0);
        var tmp : Int;
        if (swapXY)
        {
            // swap x and y
            tmp = x0;x0 = y0;y0 = tmp;  // swap x0 and y0  
            tmp = x1;x1 = y1;y1 = tmp;
        }
        if (x0 > x1)
        {
            // make sure x0 < x1
            tmp = x0;x0 = x1;x1 = tmp;  // swap x0 and x1  
            tmp = y0;y0 = y1;y1 = tmp;
        }
        var deltax : Int = Std.int(x1 - x0);
        var deltay : Int = MathUtils.floor(MathUtils.iabs(y1 - y0));
        var error : Int = MathUtils.floor(deltax / 2);
        var y : Int = y0;
        var x : Int;
        var ystep : Int = ((y0 < y1)) ? 1 : -1;
        
        if (swapXY)
        {
            // Y / X
            for (x in x0...x1 + 1)
            {
                if (!rayCanPass(y, x))
                {
                    return false;
                }
                error -= deltay;
                if (error < 0)
                {
                    y += ystep;
                    error = Std.int(error + deltax);
                }
            }
        }
        else
        {
            // X / Y
            for (x in x0...x1 + 1)
            {
                if (!rayCanPass(x, y))
                {
                    return false;
                }
                error -= deltay;
                if (error < 0)
                {
                    y += ystep;
                    error = Std.int(error + deltax);
                }
            }
        }
        return true;
    }
    
    public inline static function checkFatLine(x0 : Int, y0 : Int, x1 : Int, y1 : Int, rayCanPass : Int->Int->Bool) : Bool
    {
        if (!rayCanPass(x0, y0))
        {
            return false;
        }
        
        if (!rayCanPass(x1, y1))
        {
            return false;
        }
        
        var swapXY : Bool = (((y1 - y0) > 0) ? (y1 - y0) : (y0 - y1)) > (((x1 - x0) > 0) ? (x1 - x0) : (x0 - x1));
        //var swapXY:Boolean = MathUtils.iabs( y1 - y0 ) > MathUtils.iabs( x1 - x0 );
        var tmp : Int;
        if (swapXY)
        {
            // swap x and y
            tmp = x0;x0 = y0;y0 = tmp;  // swap x0 and y0  
            tmp = x1;x1 = y1;y1 = tmp;
        }
        if (x0 > x1)
        {
            // make sure x0 < x1
            tmp = x0;x0 = x1;x1 = tmp;  // swap x0 and x1  
            tmp = y0;y0 = y1;y1 = tmp;
        }
        var deltax : Int = Std.int(x1 - x0);
        var deltay : Int = MathUtils.floor(((y1 - y0) > 0) ? (y1 - y0) : (y0 - y1));
        //var deltay:int = MathUtils.floor( MathUtils.iabs( y1 - y0 ) );
        var error : Int = MathUtils.floor(deltax / 2);
        var y : Int = y0;
        var x : Int;
        var ystep : Int = ((y0 < y1)) ? 1 : -1;
        
        if (swapXY)
        {
            // Y / X
            for (x in x0...x1 + 1)
            {
                if (!rayCanPass(y, x))
                {
                    return false;
                }
                
                error -= deltay;
                if (error < 0)
                {
                    if (x < x1)
                    {
                        if (!rayCanPass(y + ystep, x))
                        {
                            return false;
                        }
                        if (!rayCanPass(y, x + 1))
                        {
                            return false;
                        }
                    }
                    y += ystep;
                    error = Std.int(error + deltax);
                }
            }
        }
        else
        {
            // X / Y
            for (x in x0...x1 + 1)
            {
                if (!rayCanPass(x, y))
                {
                    return false;
                }
                
                error -= deltay;
                if (error < 0)
                {
                    if (x < x1)
                    {
                        if (!rayCanPass(x, y + ystep))
                        {
                            return false;
                        }
                        if (!rayCanPass(x + 1, y))
                        {
                            return false;
                        }
                    }
                    y += ystep;
                    error = Std.int(error + deltax);
                }
            }
        }
        return true;
    }
    
    public inline static function checkFatOuterLine(x0 : Int, y0 : Int, x1 : Int, y1 : Int, rayCanPass : Int->Int->Bool) : Bool
    {
        if (!rayCanPass(x0, y0))
        {
            return false;
        }
        
        /*if( !rayCanPass(x1,y1) )
				return false;*/
        
        var swapXY : Bool = (((y1 - y0) > 0) ? (y1 - y0) : (y0 - y1)) > (((x1 - x0) > 0) ? (x1 - x0) : (x0 - x1));
        //var swapXY:Boolean = MathUtils.iabs( y1 - y0 ) > MathUtils.iabs( x1 - x0 );
        var tmp : Int;
        if (swapXY)
        {
            // swap x and y
            tmp = x0;x0 = y0;y0 = tmp;  // swap x0 and y0  
            tmp = x1;x1 = y1;y1 = tmp;
        }
        if (x0 > x1)
        {
            // make sure x0 < x1
            tmp = x0;x0 = x1;x1 = tmp;  // swap x0 and x1  
            tmp = y0;y0 = y1;y1 = tmp;
        }
        var deltax : Int = Std.int(x1 - x0);
        var deltay : Int = MathUtils.floor(((y1 - y0) > 0) ? (y1 - y0) : (y0 - y1));
        //var deltay:int = MathUtils.floor( MathUtils.iabs( y1 - y0 ) );
        var error : Int = MathUtils.floor(deltax / 2);
        var y : Int = y0;
        var x : Int;
        var ystep : Int = ((y0 < y1)) ? 1 : -1;
        var ret:Bool = true;
        if (swapXY)
        {
            // Y / X
            for (x in x0...x1 + 1)
            {
                if (x != x0 && !rayCanPass(y, x))
                {
                    //return x == x1;
					ret = x == x1;
					break;
                }
                
                error -= deltay;
                if (error < 0)
                {
                    if (x < x1)
                    {
                        if (x != x0 && !rayCanPass(y + ystep, x))
                        {
                            ret = x == x1;
							break;
                        }
                        if (x != x0 && !rayCanPass(y, x + 1))
                        {
                            ret = x == x1;
							break;
                        }
                    }
                    y += ystep;
                    error = Std.int(error + deltax);
                }
            }
        }
        else
        {
            // X / Y
            for (x in x0...x1 + 1)
            {
                if (x != x0 && !rayCanPass(x, y))
                {
                    ret = x == x1;
					break;
                }
                
                error -= deltay;
                if (error < 0)
                {
                    if (x < x1)
                    {
                        if (x != x0 && !rayCanPass(x, y + ystep))
                        {
                            ret = x == x1;
							break;
                        }
                        if (x != x0 && !rayCanPass(x + 1, y))
                        {
                            ret = x == x1;
							break;
                        }
                    }
                    y += ystep;
                    error = Std.int(error + deltax);
                }
            }
        }
        return ret;
    }
	
}

