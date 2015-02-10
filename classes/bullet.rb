require_relative '../modules/draw.rb'

class Bullet
  include Draw
  attr_accessor :x, :y

  def initialize window, x, y, vel_x, vel_y, angle
    @window = window
    @image = Gosu::Image.new(window, "images/bullet.png", false)

    @x = x
    @y = y
    @angle = angle

    @vel_x = vel_x
    @vel_y = vel_y
  end

  def move
    @vel_x += Gosu::offset_x(@angle, 0.5)
    @vel_y += Gosu::offset_y(@angle, 0.5)

    @x += @vel_x
    @y += @vel_y

    @vel_x *= 0.95
    @vel_y *= 0.95
  end
end