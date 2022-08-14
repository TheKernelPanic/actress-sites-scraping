module Helpers
  def self.slug_actress_generate(canonicalName)
    return canonicalName.downcase
               .gsub('á', 'a')
               .gsub('é', 'e')
               .gsub('í', 'i')
               .gsub('ó', 'o')
               .gsub('ú', 'u')
               .gsub(' ', '-')
               .gsub(/[^a-z0-9\-]/, '')
  end
end