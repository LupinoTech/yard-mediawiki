# frozen_string_literal: true
#include Helpers::HtmlHelper
include Helpers::ModuleHelper
include Helpers::MWHelper

def init
  options.objects = objects = run_verifier(options.objects)
  options.serializer.extension="mw"
  return serialize_onefile if options.onefile

  generate_assets # Generates the overview lists
  serialize('_index.mw')
  options.files.each_with_index do |file, _i|
    serialize_file(file, file.title)
  end

  options.delete(:objects)
  options.delete(:files)

  objects.each do |object|
    begin
      serialize(object)
    rescue => e
      path = options.serializer.serialized_path(object)
      log.error "Exception occurred while generating '#{path}'"
      log.backtrace(e)
    end
  end
end

# Generate an MW document for the specified object. This method is used by
# most of the objects found in the Registry.
# @param [CodeObject] object to be saved to the MW file
def serialize(object)
  options.object = object
  serialize_index(options) if object == '_index.mw' && options.readme.nil?
  Templates::Engine.with_serializer(object, options.serializer) do
    T('layout').run(options)
  end
end

# Generate the documentation output in one file (--one-file) which will load the
# contents of all the javascript and css and output the entire contents without
# depending on any additional files
def serialize_onefile
  Templates::Engine.with_serializer('index.mw', options.serializer) do
    T('onefile').run(options)
  end
end

# Generate the index document for the output
# @params [Hash] options contains data and flags that influence the output
def serialize_index(options)
  Templates::Engine.with_serializer('index.mw', options.serializer) do
    T('layout').run(options.merge(:index => true))
  end
end

# Generate a single file with the layout template applied. This is
# generally the README file or files specified on the command-line.
#
# @param [File] file object to be saved to the output
# @param [String] title currently unused
#
# @see layout#diskfile
def serialize_file(file, title = nil) # rubocop:disable Lint/UnusedMethodArgument
  options.object = Registry.root
  options.file = file
  outfile = 'file.' + file.name + '.mw'

  serialize_index(options) if file == options.readme
  Templates::Engine.with_serializer(outfile, options.serializer) do
    T('layout').run(options)
  end
  options.delete(:file)
end

#
# Generates a file to the output with the specified contents.
#
# @example saving a custom html file to the documentation root
#
#   asset('my_custom.mw','== Title ==\n\nContent')
#
# @param [String] path relative to the document output where the file will be
#   created.
# @param [String] content the contents that are saved to the file.
def asset(path, content)
  path.gsub!(".html", '.template')
  if options.serializer
    log.capture("Generating asset #{path}") do
      options.serializer.serialize(path, content)
    end
  end
end

def menu_lists
  Object.new.extend(T('layout')).menu_lists
end

# Generates the navigation templates (i.e. class, method, and file)
#   based on the the values returned from the layout's menu_list
#   method.
def generate_assets
  @object = Registry.root

  layout = Object.new.extend(T('layout'))
  layout.menu_lists.each do |list|
    list_generator_method = "generate_#{list[:type]}_list"
    if respond_to?(list_generator_method)
      send(list_generator_method)
    else
      log.error "Unable to generate '#{list[:title]}' list because no method " \
                "'#{list_generator_method}' exists"
    end
  end
end

# Generate a searchable method list in the output
# @see ModuleHelper#prune_method_listing
def generate_method_list
  @items = prune_method_listing(Registry.all(:method), false)
  if @items.length < 1
    log.debug("No Method list generated.")
    YardMediawiki::YardMediawikiAPI::has_methods = false
    return
  else
    @items = @items.reject {|m| m.name.to_s =~ /=$/ && m.is_attribute? }
    @items = @items.sort_by {|m| m.name.to_s }
    @list_title = "Method List"
    @list_type = "method"
    generate_list_contents
  end
end

# Generate a searchable class list in the output
def generate_class_list
  @items = options.objects if options.objects
  if @items.length < 1
    log.debug("No Class list generated.")
    YardMediawiki::YardMediawikiAPI::has_classes = false
    return
  else
    @list_title = "Class List"
    @list_type = "class"
    generate_list_contents
  end
end

# Generate a searchable file list in the output
def generate_file_list
  @file_list = true
  @items = options.files
  if @items.length < 1
    log.debug("No File list generated.")
    YardMediawiki::YardMediawikiAPI::has_files=false
    return
  else
    @list_title = "File List"
    @list_type = "file"
    generate_list_contents
    @file_list = nil
  end
end

def generate_list_contents
  asset(url_for_list(@list_type), erb(:full_list))
end

# @api private
class TreeContext
  def initialize
    @depth = 0
    @even_odd = Alternator.new(:even, :odd)
  end

  def nest
    @depth += 1
    yield
    @depth -= 1
  end

  # @return [String] Returns a css pixel offset, e.g. "30px"
  def indent
    "#{(@depth + 2) * 15}px"
  end

  def classes
    classes = []
    classes << 'collapsed' if @depth > 0
    classes << @even_odd.next if @depth < 2
    classes
  end

  class Alternator
    def initialize(first, second)
      @next = first
      @after = second
    end

    def next
      @next, @after = @after, @next
      @after
    end
  end
end

# @return [String] HTML output of the classes to be displayed in the
#    full_list_class template.
def class_list(root = Registry.root, tree = TreeContext.new, depth = 1)
  out = String.new("")
  children = run_verifier(root.children)
  if root == Registry.root
    children += @items.select {|o| o.namespace.is_a?(CodeObjects::Proxy) }
  end
  children.compact.sort_by(&:path).each do |child|
    next unless child.is_a?(CodeObjects::NamespaceObject)
    name = child.namespace.is_a?(CodeObjects::Proxy) ? child.path : child.name
    has_children = run_verifier(child.children).any? {|o| o.is_a?(CodeObjects::NamespaceObject) }
    out << "\n#{'*' * depth} <div id=\"object_#{child.path}\""
    out << " class=\"mw-collapsible\"" if has_children
    out << ">"
    out << mw_linkify(child, name)
    out << " &lt; #{child.superclass.name}" if child.is_a?(CodeObjects::ClassObject) && child.superclass
    tree.nest do
      out << "\n  <div class=\"mw-collapsible-content\">#{class_list(child, tree, depth+1)}</div>" if has_children
    end
  end
  out
end
