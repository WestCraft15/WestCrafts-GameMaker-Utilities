can_collide = function(_id, _x, _y)
{
    var _diff_x = _x - _id.x
    var _diff_y = _y - _id.y
    
    if (image_xscale > 0)
    {
        var _height = y + sprite_height - ((_id.bbox_right + _x - _id.x - x) / sprite_width * sprite_height)
        return _height < (_id.bbox_bottom + _y - _id.y)
    }
    else
    {
        var _height = y + sprite_height - ((_id.bbox_left + _x - _id.x - x) / sprite_width * sprite_height)
        return _height < (_id.bbox_bottom + _y - _id.y)
    }
}
