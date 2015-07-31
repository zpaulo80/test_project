# -*- encoding : utf-8 -*-
require 'httparty'
# Methods to work HTTParty
# @author jose paulo martins
module HTTP
  attr_accessor :http_response
  include Log

  public
  # Http GET Request
  # @param url [String] target url
  # @option args [Hash] optional arguments to the request
  # @return [HTTParty] response
  def get (url, args={})
    args = {
        headers: default_headers,
        format: :json
    }.recursive_merge args

    execute_http_request :get, url, args
  end

  # Http POST Request
  # @param url [String] target url
  # @option args [Hash] optional arguments to the request
  # @return [HTTParty] response
  def post (url, args={})
      args = {
          headers: default_headers,
          format: :json
      }.recursive_merge args

    execute_http_request :post, url, args
  end

  # Http PUT Request
  # @param url [String] target url
  # @option args [Hash] optional arguments to the request
  # @return [HTTParty] response
  def put (url, args={})
    args = {
        headers: default_headers,
        format: :json
    }.recursive_merge args

    execute_http_request :put, url, args
  end

  # Http DELETE Request
  # @param url [String] target url
  # @option args [Hash] optional arguments to the request
  # @return [HTTParty] response
  def delete (url, args={})
    args = {
        headers: default_headers,
        format: :json
    }.recursive_merge args

    execute_http_request :delete, url, args
  end

  private
  # Generic HTTP Request execution. Logs relevant info and translates protocol codes.
  # @param [String] method - which HTTP method to use. Must conform to one of the methods in HTTP (get,post,delete,put)
  # @param [String] url - the url to send the request
  # @param [Hash] args - request attributes
  def execute_http_request (method, url, args)
    @http_request = method, url.clone, args.clone
    self.http_response = HTTParty.send method, url, args
    Log.debug "#{@http_response.request.http_method.to_s.split('::').last.upcase} - URL: #{@http_response.request.last_uri}"
    Log.debug 'HEADER:'
    Log.debug http_response.request.options[:headers]
    # Log.debug @http_response.request.options[:body] if @http_response.request.options[:body]
    Log.debug 'BODY:' if http_response
    Log.debug http_response if http_response
    http_response
  end

end


class Hash

  def recursive_merge(other_hash)
    self.merge(other_hash) do |key, _old, _new|
      _old.is_a?(Hash) ? _old.recursive_merge(_new) : _new
    end
  end

end