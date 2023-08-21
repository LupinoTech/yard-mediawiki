module YardMediawiki
  class YardMediawikiAPI
    @default_ns = ""
    @use_smw = false
    @template_prefix = "yardoc_"
    @smw_prefix = "Yardoc "
    @has_classes = true
    @has_files = true
    @has_methods = true

    def self.has_methods ; return @has_methods end
    def self.has_files ; return @has_files end
    def self.has_classes ; return @has_classes end
    def self.use_smw; return @use_smw end
    def self.smw_prefix ; return @smw_prefix end
    def self.default_ns ; return @default_ns end
    def self.template_prefix ; return @template_prefix end

    def self.has_methods=(val) ; @has_methods = val end
    def self.has_classes=(val) ; @has_classes = val end
    def self.has_files=(val) ; @has_files = val end
    def self.use_smw=(val) ; @use_smw = val end
    def self.default_ns=(val) ;  @default_ns = val end
    def self.template_prefix=(val) ; @template_prefix = val end
    def self.smw_prefix=(val) ; @smw_prefix = val end

  end
end
