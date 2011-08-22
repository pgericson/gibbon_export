require 'active_support'
require 'httparty'
require 'json'
require 'cgi'

module GibbonExport
  class API
    include HTTParty
    format :plain
    default_timeout 30

    attr_accessor :apikey, :timeout

    def initialize(apikey = nil, extra_params = {})
      @apikey = apikey
      @default_params = {:apikey => apikey}.merge(extra_params)
    end

    def apikey=(value)
      @apikey = value
      @default_params = @default_params.merge({:apikey => @apikey})
    end

    def base_api_url
      dc = @apikey.blank? ? '' : "#{@apikey.split("-").last}."
      "https://#{dc}api.mailchimp.com/export/1.0/list/"
    end

  def call(method, params = {})
    url = base_api_url
    tmp_params = @default_params.merge(params)
    params = {}
    tmp_params.each do |k,v| 
      params[CGI::escape(k.to_s)] = CGI::escape(v.to_s)
    end

    response = GibbonExport::API.post(url, :query => params)
    begin
      response = parse_bulk(response.body)
    rescue
      response = response.body
    end
    response
  end

  def parse_bulk(body)
    if body[0] == "{"
      result_array = ActiveSupport::JSON.decode(body)
    else
      header_done = false
      result_array = []
      column_names = []
      body.each_line do |l|
        data = l.gsub(/(^\[|\]\n$)/,'').gsub(/\"/,'').split(",")
        if header_done == false
          column_names = data.map{|d| d.gsub(/ /, '_').downcase }
          header_done = true
        else
          line_hash = {}
          column_names.each_with_index do |name,i|
            line_hash[name.downcase] = data[i] if data[i] != "null"
          end
          result_array << line_hash
        end
      end
      result_array
    end
  end

  def method_missing(method, *args)
    method = method.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase } #Thanks for the gsub, Rails
    method = method[0].chr.downcase + method[1..-1].gsub(/aim$/i, 'AIM')
    args = {} unless args.length > 0
    args = args[0] if (args.class.to_s == "Array")
    call(method, args)
  end

  end
end
