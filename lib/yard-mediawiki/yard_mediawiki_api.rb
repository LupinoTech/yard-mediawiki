module YardMediawiki
  class YardMediawikiAPI
    @default_ns = ""
    @use_smw = false
    @template_prefix = "yardoc_"
    @smw_prefix = "Yardoc "

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

    def self.template_prefix
      return @template_prefix
    end

    def self.template_prefix=(val)
      @template_prefix = val
    end

    def self.smw_prefix
      return @smw_prefix
    end

    def self.smw_prefix=(val)
      @smw_prefix = val
    end

  end
end
