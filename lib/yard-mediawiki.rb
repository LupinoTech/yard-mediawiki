require 'yard'
require_relative "yard-mediawiki/command_line_options"
require_relative "yard-mediawiki/yard_mediawiki_api"

YARD::CLI::YardoptsCommand.prepend YardMediawiki::CommandLineOptions

#Own class to provide the template to yardoc

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
    File.join(__dir__, "..", "templates")
  end
end

YardMediawiki.init
