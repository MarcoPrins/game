require 'gosu'

class GameWindow < Gosu::Window
  attr_accessor :width, :height, :bullets, :player_1, :player_2

  def initialize
    # Window width and height
    @width = 1200
    @height = 700

    #@font = Gosu::Font.new(self, Gosu::default_font_name, 20)

    # Create window
    super @width, @height, false
    self.width = @width
    self.height = @height
    self.caption = "==========GAME==========="
    Dir['./**/*.rb'].each{ |f| require f } # review

    # Create players
    @player_1 = Player.new(self, "images/player_white.png")
    @player_1.warp( (@width/3)*2 , @height/2 )
    @player_2 = Player.new(self, "images/player_pink.png")
    @player_2.warp( (@width/3)*1 , @height/2 )
    # Boolean that prevents multiple collisions at once
    @collision_possible = true

    # List of all bullets
    @bullets = []
  end

  def update
    listen_player_1
    listen_player_2

    detect_collisions

    @bullets.map &:update_and_move
    @player_2.update_and_move
    @player_1.update_and_move
  end

  def draw
    @bullets.map &:draw
    @player_1.draw
    @player_2.draw
  end

  private
    def detect_collisions
      respond_to_player_collisions
      respond_to_bullet_hits
    end

    def respond_to_player_collisions
      if Gosu.distance(@player_1.x, @player_1.y, @player_2.x, @player_2.y) < 30
        collide if @collision_possible
        @collision_possible = false
      else
        @collision_possible = true
      end
    end

    def respond_to_bullet_hits
      @bullets.map &:check_collisions
    end

    def collide
      ratio = 0.8

      @player_1.vel_x += (@player_2.vel_x * ratio)
      @player_2.vel_x += (@player_1.vel_x * ratio)

      @player_1.vel_y += (@player_2.vel_y * ratio)
      @player_2.vel_y += (@player_1.vel_y * ratio)
    end

    def listen_player_1
      if button_down? Gosu::KbLeft
        @player_1.turn_left
      end
      if button_down? Gosu::KbRight
        @player_1.turn_right
      end
      if button_down? Gosu::KbUp
        @player_1.accelerate
      end
      if button_down? Gosu::KbDown
        @player_1.decelerate
      end

      if button_down? Gosu::KbComma
        @player_1.fire_bullet
      end
    end

    def listen_player_2
      if button_down? Gosu::KbA
        @player_2.turn_left
      end
      if button_down? Gosu::KbD
        @player_2.turn_right
      end
      if button_down? Gosu::KbW
        @player_2.accelerate
      end
      if button_down? Gosu::KbS
        @player_2.decelerate
      end

      if button_down? Gosu::KbZ
        @player_2.fire_bullet
      end
    end
end

window = GameWindow.new
window.show