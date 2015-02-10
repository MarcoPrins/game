require_relative '../modules/draw.rb'

class Player
  include Draw
  attr_accessor :window, :x, :y, :vel_x, :vel_y

  def initialize(window, image)
    @window = window
    @image = Gosu::Image.new(window, image, false)

    @x = window.width/2
    @y = window.height/2
    @angle = 0.0

    @vel_x = 0.0
    @vel_y = 0.0

    @score = 0
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def turn_left
    @angle -= 4
  end

  def turn_right
    @angle += 4
  end

  def accelerate
    @vel_x += Gosu::offset_x(@angle, 0.5)
    @vel_y += Gosu::offset_y(@angle, 0.5)
  end

  def decelerate
    @vel_x -= Gosu::offset_x(@angle, 0.5)
    @vel_y -= Gosu::offset_y(@angle, 0.5)
  end

  def move
    # Move
    @x += @vel_x
    @y += @vel_y

    # Prevent window exit
    @x %= @window.width
    @y %= @window.height

    # Simulate air resistance
    @vel_x *= 0.95
    @vel_y *= 0.95
  end

  def fire_bullet
    self.window.bullets << Bullet.new(window, @x, @y, @angle)
  end
end