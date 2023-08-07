# require_relative 'mediawiki_api.rb'

module YardMediawiki
  module CommandLineOptions
    def common_options(opts)
      super

      opts.separator ''
      opts.separator 'YardMediawiki plugin options'

      opts.on('--mw-namespace [NS]',
              'Namespace for links '\
              "(Default: \"#{YardMediawiki::YardMediawikiAPI.default_ns}\")"
             ) do |ns|
        YardMediawiki::YardMediawikiAPI.default_ns = ns
      end

      opts.on("--[no-]mw-semantic", TrueClass, "use Semantic Properties " "(Default: #{YardMediawiki::YardMediawikiAPI.use_smw.inspect})") do |semantic|
        YardMediawiki::YardMediawikiAPI.use_smw = semantic
      end

      opts.separator ''
      opts.separator 'Generic options'

    end
  end
end

