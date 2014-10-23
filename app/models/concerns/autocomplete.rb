module Autocomplete
  extend ActiveSupport::Concern

  included do
    field :autocomplete
    field :autocomplete_length
    before_save :generate_autocomplete
  end

  # callback to populate :autocomplete
  def generate_autocomplete
    s = self.name
    s = s.truncate(100, omission: "", separator: " ") if s.length > 100
    write_attribute(:autocomplete, Autocomplete.normalize(s))
    write_attribute(:autocomplete_length, Autocomplete.normalize(s).size)
  end

  # turn strings into autocomplete keys
  def self.normalize(s)
    norm = s.upcase.gsub("'", "")
    .gsub('"', "")
    .gsub(/[à|À|á|Á|ã|Ã|â|Â|ä|Ä]/,"A")
    .gsub(/[é|É|è|È|ê|Ê|ẽ|Ẽ|ë|Ë]/,'E')
    .gsub(/[^A-Z0-9 ]/, " ")
    .gsub(/ THE /, "")
    .gsub(" AND ", " & ")
    .gsub(" ET ", " & ")
    .squish
    norm
  end
end

