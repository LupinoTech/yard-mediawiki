module YardMediawiki
  class Mediawiki_API
    default_ns = ""

    def self.default_ns
      return default_ns
    end

    def self.default_ns=(val)
      default_ns = val
    end

  end
end
