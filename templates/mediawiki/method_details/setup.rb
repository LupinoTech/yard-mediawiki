# frozen_string_literal: true
include Helpers::HtmlHelper
def init
  sections :header, [:method_signature, T('docstring'), :source]
end

def source
  return if owner != object.namespace
  return if Tags::OverloadTag === object
  return if object.source.nil?
  erb(:source)
end
