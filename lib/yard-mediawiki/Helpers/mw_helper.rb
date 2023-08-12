module YARD::Templates::Helpers
  module MWHelper
    include BaseHelper

    def mw_linkify(*args)
      if args.first.is_a?(String)
        case args.first
        when %r{://}, /^mailto:/
return "url #{args}"
          link_url(args[0], args[1], {:target => '_parent'}.merge(args[2] || {}))
        when /^include:file:(\S+)/
return "include file #{args}"
          file = $1
          relpath = File.relative_path(Dir.pwd, File.expand_path(file))
          if relpath =~ /^\.\./
            log.warn "Cannot include file from path `#{file}'"
            ""
          elsif File.file?(file)
            link_include_file(file)
          else
            log.warn "Cannot find file at `#{file}' for inclusion"
            ""
          end
        when /^include:(\S+)/
return "object #{args}"
          path = $1
          obj = YARD::Registry.resolve(object.namespace, path)
          if obj
            link_include_object(obj)
          else
            log.warn "Cannot find object at `#{path}' for inclusion"
            ""
          end
        when /^render:(\S+)/
return "render #{args}"
          path = $1
          obj = YARD::Registry.resolve(object, path)
          if obj
            opts = options.dup
            opts.delete(:serializer)
            obj.format(opts)
          else
            ''
          end
        when /^file:(\S+?)(?:#(\S+))?$/
return "file #{args}"
          link_file($1, args[1] ? args[1] : nil, $2)
        else
          mw_link_object(*args)
        end
      else
        mw_link_generic(*args)
      end
    end

    def mw_link_object(obj, title = nil)
      return title if title
      case obj
      when YARD::CodeObjects::Base, YARD::CodeObjects::Proxy
        "obj.title=" + obj.title
      when String, Symbol
        "STR=" + P(obj).title
      else
        "onj=" + obj
      end
    end


    def mw_link_generic(*args)
      path = if args[0].parent && !args[0].parent.root?
               [args[0].parent.path, args[0].name.to_s].join("/")
             else
               args[0].name.to_s
             end
      path = "#{YardMediawiki::YardMediawikiAPI::default_ns}:#{path}"
      return "[[#{path}|#{args[1]}]]"
    end

    # def mw_linkify(target, name)
    #   "[[#{target}|#{name}]]"
    # end
  end
end
