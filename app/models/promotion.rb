class Promotion < Sequel::Model
  many_to_one :game
end
