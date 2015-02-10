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
end