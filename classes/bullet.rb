require_relative '../modules/draw.rb'

class Bullet
  include Draw
  attr_accessor :x, :y

  def initialize window, x, y, angle
    @window = window
    @image = Gosu::Image.new(window, "images/bullet.png", false)

    @x = x
    @y = y
    @angle = angle
  end

  def move
    @x += Gosu::offset_x(@angle, 0.5)
    @y += Gosu::offset_y(@angle, 0.5)
  end
end