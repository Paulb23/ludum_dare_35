extends Node2D

var FULL_COLOR = Color(1.0, 0.1, 0.1)
var EMPTY_COLOR = Color(1.0, 0.1, 0.1)
var BORDER_COLOR = Color(0.66, 0.66, 0.66)
var BORDER_SIZE = 0.01

var rect
var innerRect
var borderColor
var percentage


func _ready():
    percentage = 1
    var scale = get_scale()
    rect = get_item_rect()
    var borderX = rect.size.x * BORDER_SIZE / scale.x
    var borderY = rect.size.y * BORDER_SIZE / scale.y
    var innerPos = Vector2(rect.pos.x + borderX, rect.pos.y + borderY)
    var innerSize = Vector2(rect.size.x - borderX * 2.0, rect.size.y - borderY * 2.0)
    innerRect = Rect2(innerPos, innerSize)


func _draw():
    draw_rect(rect, BORDER_COLOR)
    var percentageRect = Rect2(innerRect.pos, innerRect.size)
    percentageRect.size.x *= percentage
    draw_rect(percentageRect, EMPTY_COLOR.linear_interpolate(FULL_COLOR, percentage))
    update()


func set_percentage(percentage):
    self.percentage = percentage
    update()