# coding: utf-8

require "danger/helpers/comments_helper"

module Danger
  module RequestSources
    class BitbucketCloudAPI
      attr_accessor :host, :project, :slug, :access_token, :pull_request_id

      def initialize(repo_slug, pull_request_id, branch_name, environment)
        @username = environment["DANGER_BITBUCKETCLOUD_USERNAME"]
        @password = environment["DANGER_BITBUCKETCLOUD_PASSWORD"]
        self.project, self.slug = repo_slug.split("/")
        self.access_token = fetch_access_token(environment)
        self.pull_request_id = pull_request_id || fetch_pr_from_branch(branch_name)
        self.host = "https://bitbucket.org/"
      end

      def inspect
        inspected = super

        if @password
          inspected = inspected.sub! @password, "********".freeze
        end

        inspected
      end

      def credentials_given?
        @username && !@username.empty? && @password && !@password.empty?
      end

      def pull_request(*)
        fetch_pr_json
      end

      def fetch_pr_json
        uri = URI(pr_api_endpoint)
        fetch_json(uri)
      end

      def fetch_last_comments
        uri = URI("#{pr_api_endpoint}/activity?limit=1000")
        fetch_json(uri)[:values].select { |v| v[:comment] }.map { |v| v[:comment] }
      end

      def delete_comment(id)
        uri = URI("#{pr_api_endpoint}/comments/#{id}")
        delete(uri)
      end

      def post_comment(text)
        uri = URI("#{pr_api_endpoint}/comments")
        body = {
          content: { 
            raw: text
          }
        }.to_json
        post(uri, body)
      end

      private

      def base_url(version)
        "https://api.bitbucket.org/#{version}.0/repositories/#{project}/#{slug}/pullrequests"
      end

      def pr_api_endpoint
        "#{base_url(2)}/#{pull_request_id}"
      end

      def prs_api_endpoint(branch_name)
        "#{base_url(2)}?q=source.branch.name=\"#{branch_name}\""
      end

      def fetch_pr_from_branch(branch_name)
        uri = URI(URI.escape(prs_api_endpoint(branch_name)))
        fetch_json(uri)[:values][0][:id]
      end

      def fetch_access_token(environment)
        oauth_key = environment["DANGER_BITBUCKETCLOUD_OAUTH_KEY"]
        oauth_secret = environment["DANGER_BITBUCKETCLOUD_OAUTH_SECRET"]
        return nil if oauth_key.nil?
        return nil if oauth_secret.nil?
        
        uri = URI.parse("https://bitbucket.org/site/oauth2/access_token")
        req = Net::HTTP::Post.new(uri.request_uri, { "Content-Type" => "application/json" })
        req.basic_auth oauth_key, oauth_secret
        req.set_form_data({'grant_type' => 'client_credentials'})
        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
            http.request(req)
        end
    
        JSON.parse(res.body, symbolize_names: true)[:access_token]
      end

      def fetch_json(uri)
        raise credentials_not_available unless credentials_given?

        req = Net::HTTP::Get.new(uri.request_uri, { "Content-Type" => "application/json" })
        if access_token.nil?
          req.basic_auth @username, @password
        else
          req["Authorization"] = "Bearer #{access_token}"
        end
        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          http.request(req)
        end
        raise error_fetching_json(uri.to_s, res.code) unless res.code == "200"

        JSON.parse(res.body, symbolize_names: true)
      end

      def post(uri, body)
        raise credentials_not_available unless credentials_given?

        req = Net::HTTP::Post.new(uri.request_uri, { "Content-Type" => "application/json" })
        if access_token.nil?
          req.basic_auth @username, @password
        else
          req["Authorization"] = "Bearer #{access_token}"
        end
        req.body = body
        Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          http.request(req)
        end
      end

      def delete(uri)
        raise credentials_not_available unless credentials_given?
        
        req = Net::HTTP::Delete.new(uri.request_uri, { "Content-Type" => "application/json" })
        if access_token.nil?
          req.basic_auth @username, @password
        else
          req["Authorization"] = "Bearer #{access_token}"
        end        
        Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          http.request(req)
        end
      end

      def credentials_not_available
        "Credentials not available. Provide DANGER_BITBUCKETCLOUD_USERNAME and DANGER_BITBUCKETCLOUD_PASSWORD as environment variables."
      end

      def error_fetching_json(url, status_code)
        "Error fetching json for: #{url}, status code: #{status_code}"
      end

    end
  end
end
