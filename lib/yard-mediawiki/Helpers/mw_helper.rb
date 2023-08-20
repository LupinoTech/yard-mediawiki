module YARD
  module Templates::Helpers
    module MWHelper
      include BaseHelper
      include HtmlHelper

      def initialize(*arg)
        super(*arg)
        @ns_prefix = YardMediawiki::YardMediawikiAPI::default_ns == "" ? "" : "#{YardMediawiki::YardMediawikiAPI::default_ns}:"
        @use_smw = YardMediawiki::YardMediawikiAPI::use_smw
        @template_prefix = YardMediawiki::YardMediawikiAPI::template_prefix
        @smw_prefix = YardMediawiki::YardMediawikiAPI::smw_prefix
      end

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
            obj = Registry.resolve(object.namespace, path)
            if obj
              link_include_object(obj)
            else
              log.warn "Cannot find object at `#{path}' for inclusion"
              ""
            end
          when /^render:(\S+)/
            return "render #{args}"
            path = $1
            obj = Registry.resolve(object, path)
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
            #return "generic #{args}"
            mw_link_object(*args)
          end
        else
          mw_link_generic(*args)
        end
      end

      def mw_link_object(obj, title = nil, anchor = nil, relative = true)
        return title if obj.nil?
        obj = Registry.resolve(object, obj, true, true) if obj.is_a?(String)
        if title
          title = title.to_s
        elsif object.is_a?(CodeObjects::Base)
          # Check if we're linking to a class method in the current
          # object. If we are, create a title in the format of
          # "CurrentClass.method_name"
          if obj.is_a?(CodeObjects::MethodObject) && obj.scope == :class && obj.parent == object
            title = h([object.name, obj.sep, obj.name].join)+"x"
          elsif obj.title != obj.path
            title = h(obj.title)
          else
            title = h(object.relative_path(obj))
          end
        else
          title = h(obj.title)
        end
        return title unless serializer
        return title if obj.is_a?(CodeObjects::Proxy)

        link = url_for(obj, anchor, relative)
        link = link ? link_url(link, title, :title => h("#{obj.title} (#{obj.type})")) : title
        "<span class='object_link'>" + link + "</span>"
      rescue Parser::UndocumentableError
        log.warn "The namespace of link #{obj.inspect} is a constant or invalid."
        title || obj.to_s
      end


      # def mw_link_object(obj, title = nil)
      #   return title if title
      #   case obj
      #   when YARD::CodeObjects::Base, YARD::CodeObjects::Proxy
      #     "obj.title=" + obj.title
      #   when String, Symbol
      #     "STR=" + P(obj).title
      #   else
      #     "onj=" + obj
      #   end
      # end


      def mw_link_generic(*args)
        path = if args[0].parent && !args[0].parent.root?
                 [args[0].parent.path, args[0].name.to_s].join("/")
               else
                 args[0].name.to_s
               end
        path = "#{YardMediawiki::YardMediawikiAPI::default_ns}:#{path}"
        return "[[#{path}|#{args[1]}]]"
      end

      def mw_semantic_property(prop, value)
        if @use_smw
          prefix = "#{@ns_prefix}#{@smw_prefix}"
          return "[[#{prefix}#{prop}::#{value}|#{value}]]"
        else
          return "[[#{@ns_prefix}#{value}|#{value}]]"
        end
      end

      def mw_template(name, content)
        return "{{#{@ns_prefix}#{@template_prefix}#{name}|#{content}}}"
      end

      def mw_url_for_index(name = @options.title)
        return "[[#{@ns_prefix}#{@options.title}|#{name}]]"
      end

    end
  end
end
