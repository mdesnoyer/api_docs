#!/usr/bin/env ruby

require "json"

class SwaggerDocument
  DEFAULT_OUTPUT_FILE = "default.json"
  DOCSET_LIST_KEY = "x-documentationSets"
  VISIBILITY_KEY = "x-onlyVisibleInDocumentationSets"

  def initialize(hash)
    @hash = hash
  end

  def self.parse(filename)
    new(JSON.parse(File.read(filename)))
  end

  def generate_docs(output_filename, docset)
    if using_documentation_sets?
        write_docs_without(output_filename, docset)
    else
      write_docs(without_documentation_set_list, output_filename)
    end
  end

  private

  attr_reader :hash

  def documentation_sets
    hash.fetch(DOCSET_LIST_KEY, [])
  end

  def using_documentation_sets?
    !documentation_sets.empty?
  end

  def without_documentation_set_list
    hash.select { |k, _| k != DOCSET_LIST_KEY}
  end

  def write_docs_without(output_filename, docset)
    write_docs(
      without_documentation_set_list.merge("paths" => paths_without_docset(docset)),
      output_filename
    )
  end

  def paths_without_docset(docset)
    paths_visible_in_docset(docset).map do |endpoint, properties|
      { endpoint => properties.select { |k, _| k != VISIBILITY_KEY } }
    end.inject(&:merge)
  end

  def write_docs(hash, filename)
    puts "Generating #{filename}..."
    File.write(filename, JSON.pretty_generate(hash))
  end

  def paths
    hash.fetch("paths", {})
  end

  def paths_visible_in_docset(docset)
    paths.select do |_, properties|
      visible_in_this_docset?(docset, properties)
    end
  end

  def visible_in_this_docset?(docset, properties)
    !properties.has_key?(VISIBILITY_KEY) || properties[VISIBILITY_KEY].include?(docset)
  end
end

if ARGV.size != 3
  $stderr.puts "Usage: #{ARGV[0]} <input> <output> <docset>"
  exit 1
end

if File.file?(ARGV[0])
  SwaggerDocument.parse(ARGV[0]).generate_docs(ARGV[1], ARGV[2])
else
  $stderr.puts "File #{ARGV[0]} doesn't exist."
  exit 1
end
