require_relative '../modules/draw.rb'

class Player
  include Draw
  attr_accessor :window,
                :x,
                :y,
                :vel_x,
                :vel_y,
                :angle,
                :health,
                :color,
                :name

  @@shoot_sound = Gosu::Sample.new("sounds/shoot.mp3")

  def initialize(window, image, name, color, length_factor)
    @window = window
    @name = name
    @color = color

    @image = Gosu::Image.new(window, image, false)
    @test_image = Gosu::Image.new(window, 'images/circle.png', false)

    @length_factor = length_factor

    @fire_counter = 0
    @health = 10

    @x = window.width/2
    @y = window.height/2

    @head_x = @x
    @head_y = @y + length_factor

    @foot_x = @x
    @foot_y = @y - length_factor

    @angle = 0.0

    @vel_x = 0.0
    @vel_y = 0.0
  end

  def update_and_move
    update
    move
  end

  def draw_test
    @test_image.draw_rot(@x, @y, 1, @angle)
    @test_image.draw_rot(@head_x, @head_y, 1, @angle)
    @test_image.draw_rot(@foot_x, @foot_y, 1, @angle)
  end

  def update
    if @fire_counter > 0
      @fire_counter -= 1
    end
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

    diff_x = Gosu::offset_x(@angle, @length_factor)
    diff_y = Gosu::offset_y(@angle, @length_factor)

    @head_x = @x + diff_x
    @head_y = @y + diff_y

    @foot_x = @x - diff_x
    @foot_y = @y - diff_y

    # Prevent window exit
    @x %= @window.width
    @y %= @window.height

    # Simulate air resistance
    @vel_x *= 0.95
    @vel_y *= 0.95
  end

  def fire_bullet
    if @fire_counter == 0
      @@shoot_sound.play
      bullets = self.window.bullets
      bullets << Bullet.new(window, self, @x, @y, @vel_x, @vel_y, @angle)
      @fire_counter = 15
    end
  end

  def touching? player, threshold
    player.is_this_point_touching_me?(@x, @y, 30) or player.is_this_point_touching_me?(@head_x, @head_y, 30) or player.is_this_point_touching_me?(@foot_x, @foot_y, 30)
  end

  def is_this_point_touching_me? x, y, threshold
    (Gosu::distance(@x,@y,x,y) < threshold) or (Gosu::distance(@head_x,@head_y,x,y) < threshold) or (Gosu::distance(@foot_x,@foot_y,x,y) < threshold)
  end
end