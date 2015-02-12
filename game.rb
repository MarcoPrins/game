require 'gosu'

class GameWindow < Gosu::Window
  attr_accessor :width,
                :height,
                :bullets,
                :player_1,
                :player_2,
                :players,
                :drug

  def initialize
    # Window width and height
    @width = 1200
    @height = 700

    @winning_song = Gosu::Sample.new(self, "sounds/dont_you.mp3")
    @game_over = false

    # Create window
    super @width, @height, false
    self.caption = "==========GAME==========="
    Dir['./**/*.rb'].each{ |f| require f } # review

    @winning_image_coordinates = []
    @winning_image = Gosu::Image.new(self, "images/drug.png", false)
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)

    @player_length_factor = 30

    # Create players
    @player_1 = Player.new(self, "images/player_white.png", "Player 1", 0xffffffff, @player_length_factor)
    @player_1.warp( (@width/3)*2 , @height/2 )
    @player_2 = Player.new(self, "images/player_pink.png", "Player 2", 0xffFD1982, @player_length_factor)
    @player_2.warp( (@width/3)*1 , @height/2 )
    # Boolean that prevents multiple collisions at once
    @collision_possible = true

    @drug = Drug.new self

    # List of all bullets
    @bullets = []
    # List of all players
    @players = [@player_1, @player_2]
  end

  def update
    listen_player_1
    listen_player_2

    detect_collisions

    @drug.update

    @bullets.map &:update_and_move
    @players.map &:update_and_move
  end

  def draw
    @bullets.map &:draw
    @players.map &:draw
    draw_health_or_end
    @drug.draw_if
  end

  def end_game loser
    if !@game_over
      @players.delete loser
      @winning_song.play
      @game_over = true
    end
  end

  private
    def draw_health_or_end
      if @game_over
        draw_end
      else
        @font.draw(@player_2.health.to_s, 10, 10, 5, 1.0, 1.0, @player_2.color)
        @font.draw(@player_1.health.to_s, @width - 30, 5, 5, 1.0, 1.0, @player_1.color)
      end
    end

    def draw_end
      winner = @players[0]
      @font.draw("Marco wins!!! (#{winner.name})", 10, 10, 5, 2.0, 2.0, winner.color)
      if rand(9) == 7
        @winning_image_coordinates << [rand(@width), rand(@height)]
      end
      @winning_image_coordinates.each do |c|
        @winning_image.draw_rot(c[0],c[1],1,1)
      end
    end

    def detect_collisions
      respond_to_player_collisions
      respond_to_bullet_hits
    end

    def respond_to_player_collisions
      if @player_1.touching? @player_2, 30
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

      if button_down? Gosu::KbLeftShift
        @player_2.fire_bullet
      end
    end
end

window = GameWindow.new
window.show