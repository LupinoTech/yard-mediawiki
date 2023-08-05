# require_relative 'mediawiki_api.rb'

module YardMediawiki
  module CommandLineOptions
    def common_options(opts)
      super

      opts.separator ''
      opts.separator 'YardMediawiki plugin options'

      opts.on('--mw-namespace [NS]',
              'Namespace for links '\
              "#{YardMediawiki::Mediawiki_API.default_ns.inspect}"
             ) do |ns|
        YardMediawiki::Mediawiki_API.default_ns = ns
        pp "set namespace to #{YardMediawiki::Mediawiki_API.default_ns}"
      end

      opts.separator ''
      opts.separator 'Generic options'

    end
  end
end

