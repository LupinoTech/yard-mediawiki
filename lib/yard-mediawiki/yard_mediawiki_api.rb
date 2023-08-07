module YardMediawiki
  class YardMediawikiAPI
    @default_ns = ""
    @use_smw = false

    def self.use_smw
      return @use_smw
    end

    def self.use_smw=(val)
      @use_smw = val
    end

    def self.default_ns
      return @default_ns
    end

    def self.default_ns=(val)
      @default_ns = val
    end

  end
end
