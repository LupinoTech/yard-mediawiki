require 'yard'

# Own class to provide the template to yardoc
module YardMediawiki

  # ctor
  def self.init
    YARD::Templates::Engine.register_template_path self.templates_path
    ## in case we need additonal markup:
    #
    # tags = [
    #   YARD::Tags::Library.define_tag('Known Bugs', :bug),
    # ]
    # YARD::Tags::Library.visible_tags |= tags
  end

  # @return [String] the path to the tempaltes folder
  def self.templates_path
    File.join(__dir__, 'templates')
  end
end

YardMediawiki.init
