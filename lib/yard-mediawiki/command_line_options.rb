# require_relative 'mediawiki_api.rb'

module YardMediawiki
  module CommandLineOptions
    def common_options(opts)
      super

      opts.separator ''
      opts.separator 'YardMediawiki plugin options'

      opts.on('--mw-namespace [NS]',
              'Namespace for links '\
              "  (Default: \"#{YardMediawiki::YardMediawikiAPI.default_ns}\")"
             ) do |ns|
        YardMediawiki::YardMediawikiAPI.default_ns = ns
      end

      opts.on("--[no-]mw-semantic", TrueClass, "use Semantic Properties " "(Default: #{YardMediawiki::YardMediawikiAPI.use_smw.inspect})") do |semantic|
        YardMediawiki::YardMediawikiAPI.use_smw = semantic
      end

      opts.on('--mw-smw-prefix [PREFIX]',
              'Prefix for all Semantic Mediawiki Properties.'\
              "  (Default: \"Yardoc \")"
             ) do |prefix|
        YardMediawiki::YardMediawikiAPI.smw_prefix = prefix
      end

      opts.on('--mw-template-prefix [PREFIX]',
              'Prefix for all templates. Note that templates are'\
              'always in the same namespace as the documentation itself,'\
              'so the value of --mw-namespace is always added to the'\
              "template's name, unless the namespace is empty."\
              "  (Default: \"yardoc_\")"
             ) do |prefix|
        YardMediawiki::YardMediawikiAPI.template_prefix = prefix
      end

      opts.separator ''
      opts.separator 'Generic options'

    end
  end
end

