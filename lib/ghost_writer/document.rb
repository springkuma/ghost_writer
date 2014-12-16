require 'ghost_writer/writer'

class GhostWriter::Document
  attr_reader :basename, :relative_path, :title, :description, :location, :request_method, :path_info, :response_format, :param_example, :status_code
  attr_accessor :header

  def initialize(basename, attrs)
    @basename         = basename
    @relative_path    = basename
    @title            = attrs[:title]
    @description      = attrs[:description]
    @location         = attrs[:location]
    @request_method   = attrs[:request_method]
    @path_info        = attrs[:path_info]

    param_example     = attrs[:param_example].stringify_keys
    @response_format  = param_example.delete("format").to_s
    @param_example    = param_example
    @status_code      = attrs[:status_code]
    @response_body    = attrs[:response_body]
  end

  def write_file(options = {})
    writer = GhostWriter::Writer.new(self, options)
    writer.write_file
  end

  def serialized_params
    param  = param_example.clone
    param.delete(:id)
    Oj.dump(param, mode: :compat)
  rescue NoMemoryError, StandardError
    puts "Param serialize error: #{param_example.inspect} of #{description} at #{location}"
    param_example.inspect
  end

  def response_body
    arrange_json(@response_body)
  end

  def response_format(json_convert_to_javascript = false)
    if json_convert_to_javascript && @response_format == "json"
      "javascript"
    else
      @response_format
    end
  end

  def content_type
    if response_format == "json"
      "application/json; charset=UTF-8"
    else
      "text/html; charset=UTF-8"
    end
  end

  private

  def arrange_json(body)
    return body unless response_format == "json"

    data = Oj.load(body)
    if data.is_a?(Array) || data.is_a?(Hash)
      JSON.pretty_generate(data)
    else
      data
    end
  rescue Oj::Error
    body
  end
end
