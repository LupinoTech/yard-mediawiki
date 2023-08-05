# require_relative 'mediawiki_api.rb'

module YardMediawiki
  module CommandLineOptions
    def common_options(opts)
      super

      opts.separator ''
      opts.separator 'YardMediawiki plugin options'

      opts.on('--mw-namespace [NS]',
              'Namespace for links '\
              "#{YardMediawiki::YardMediawikiAPI.default_ns.inspect}"
             ) do |ns|
        YardMediawiki::YardMediawikiAPI.default_ns = ns
        pp "set namespace to #{YardMediawiki::YardMediawikiAPI.default_ns}"
      end

      opts.separator ''
      opts.separator 'Generic options'

    end
  end
end

