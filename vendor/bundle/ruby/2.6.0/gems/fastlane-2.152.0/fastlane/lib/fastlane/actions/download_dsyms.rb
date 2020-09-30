module Fastlane
  module Actions
    module SharedValues
      DSYM_PATHS = :DSYM_PATHS
    end
    class DownloadDsymsAction < Action
      # rubocop:disable Metrics/PerceivedComplexity
      def self.run(params)
        require 'spaceship'
        require 'net/http'

        UI.message("Login to App Store Connect (#{params[:username]})")
        Spaceship::Tunes.login(params[:username])
        Spaceship::Tunes.select_team
        UI.message("Login successful")

        # Get App
        app = Spaceship::Application.find(params[:app_identifier])
        unless app
          UI.user_error!("Could not find app with bundle identifier '#{params[:app_identifier]}' on account #{params[:username]}")
        end

        # Process options
        version = params[:version]
        build_number = params[:build_number]
        platform = params[:platform]
        output_directory = params[:output_directory]
        wait_for_dsym_processing = params[:wait_for_dsym_processing]
        wait_timeout = params[:wait_timeout]
        min_version = Gem::Version.new(params[:min_version]) if params[:min_version]

        # Set version if it is latest
        if version == 'latest'
          # Try to grab the edit version first, else fallback to live version
          UI.message("Looking for latest version...")
          latest_version = app.edit_version(platform: platform) || app.live_version(platform: platform)

          UI.user_error!("Could not find latest version for your app, please try setting a specific version") if latest_version.version.nil?

          latest_candidate_build = latest_version.candidate_builds.max_by(&:upload_date)
          if latest_candidate_build.nil?
            version = latest_version.version
            build_number = latest_version.build_version
          else
            # The build_version of a candidate build does not always match the one in latest_version so get the version and build number from the same place.
            version = latest_candidate_build.train_version
            build_number = latest_candidate_build.build_version
          end
        elsif version == 'live'
          UI.message("Looking for live version...")
          live_version = app.live_version(platform: platform)

          UI.user_error!("Could not find live version for your app, please try setting 'latest' or a specific version") if live_version.nil?

          # No need to search for candidates, because released App Store version should only have one build
          version = live_version.version
          build_number = live_version.build_version
        end

        # Remove leading zeros from version string (eg. 1.02 -> 1.2)
        if version
          version = version.split(".").map(&:to_i).join(".")
        end

        # Make sure output_directory has a slash on the end
        if output_directory && !output_directory.end_with?('/')
          output_directory += '/'
        end

        # Write a nice message
        message = []
        message << "Looking for dSYM files for '#{params[:app_identifier]}' on platform #{platform}"
        message << "v#{version}" if version
        message << "(#{build_number})" if build_number
        UI.message(message.join(" "))

        app.tunes_all_build_trains(platform: platform).each do |train|
          message = []
          message << "Found train (version): #{train.version_string}"
          message << ", comparing to supplied version: #{version}" if version
          UI.verbose(message.join(" "))

          if version && version != train.version_string
            UI.verbose("Version #{version} doesn't match: #{train.version_string}")
            next
          end

          if min_version && min_version > Gem::Version.new(train.version_string)
            UI.verbose("Min version #{min_version} not reached: #{train.version_string}")
            next
          end

          app.tunes_all_builds_for_train(train: train.version_string, platform: platform).each do |build|
            message = []
            message << "Found build version: #{build.build_version}"
            message << ", comparing to supplied build_number: #{build_number}" if build_number
            UI.verbose(message.join(" "))

            if build_number && build.build_version != build_number
              UI.verbose("build_version: #{build.build_version} doesn't match: #{build_number}")
              next
            end

            UI.verbose("Build_version: #{build.build_version} matches #{build_number}, grabbing dsym_url") if build_number

            start = Time.now
            download_url = nil

            loop do
              begin
                build_details = app.tunes_build_details(train: train.version_string, build_number: build.build_version, platform: platform)
                download_url = build_details.dsym_url
                UI.verbose("dsym_url: #{download_url}")
              rescue Spaceship::TunesClient::ITunesConnectError => ex
                UI.error("Error accessing dSYM file for build\n\n#{build}\n\nException: #{ex}")
              end

              unless download_url
                if !wait_for_dsym_processing || (Time.now - start) > wait_timeout
                  # In some cases, AppStoreConnect does not process the dSYMs, thus no error should be thrown.
                  UI.message("Could not find any dSYM for #{build.build_version} (#{train.version_string})")
                else
                  UI.message("Waiting for dSYM file to appear...")
                  sleep(30)
                  next
                end
              end

              break
            end

            if download_url
              self.download(download_url, app.bundle_id, train.version_string, build.build_version, output_directory)
              break if build_number
            else
              UI.message("No dSYM URL for #{build.build_version} (#{train.version_string})")
            end
          end
        end

        if (Actions.lane_context[SharedValues::DSYM_PATHS] || []).count == 0
          UI.error("No dSYM files found on App Store Connect - this usually happens when no recompiling has happened yet")
        end
      end
      # rubocop:enable Metrics/PerceivedComplexity

      def self.download(download_url, bundle_id, train_number, build_version, output_directory)
        result = self.download_file(download_url)
        path   = write_dsym(result, bundle_id, train_number, build_version, output_directory)
        UI.success("🔑  Successfully downloaded dSYM file for #{train_number} - #{build_version} to '#{path}'")

        Actions.lane_context[SharedValues::DSYM_PATHS] ||= []
        Actions.lane_context[SharedValues::DSYM_PATHS] << File.expand_path(path)
      end

      def self.write_dsym(data, bundle_id, train_number, build_number, output_directory)
        file_name = "#{bundle_id}-#{train_number}-#{build_number}.dSYM.zip"
        if output_directory
          file_name = output_directory + file_name
        end
        File.binwrite(file_name, data)
        file_name
      end

      def self.download_file(url)
        uri = URI.parse(url)
        if ENV['http_proxy']
          UI.verbose("Found 'http_proxy' environment variable so connect via proxy")
          proxy_uri = URI.parse(ENV['http_proxy'])
          http = Net::HTTP.new(uri.host, uri.port, proxy_uri.host, proxy_uri.port)
        else
          http = Net::HTTP.new(uri.host, uri.port)
        end
        http.use_ssl = (uri.scheme == "https")
        res = http.get(uri.request_uri)
        res.body
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Download dSYM files from App Store Connect for Bitcode apps"
      end

      def self.details
        sample = <<-SAMPLE.markdown_sample
          ```ruby
          lane :refresh_dsyms do
            download_dsyms                  # Download dSYM files from iTC
            upload_symbols_to_crashlytics   # Upload them to Crashlytics
            clean_build_artifacts           # Delete the local dSYM files
          end
          ```
        SAMPLE

        [
          "This action downloads dSYM files from App Store Connect after the ipa gets re-compiled by Apple. Useful if you have Bitcode enabled.".markdown_preserve_newlines,
          sample
        ].join("\n")
      end

      def self.available_options
        user = CredentialsManager::AppfileConfig.try_fetch_value(:itunes_connect_id)
        user ||= CredentialsManager::AppfileConfig.try_fetch_value(:apple_id)

        [
          FastlaneCore::ConfigItem.new(key: :username,
                                       short_option: "-u",
                                       env_name: "DOWNLOAD_DSYMS_USERNAME",
                                       description: "Your Apple ID Username for App Store Connect",
                                       default_value: user,
                                       default_value_dynamic: true),
          FastlaneCore::ConfigItem.new(key: :app_identifier,
                                       short_option: "-a",
                                       env_name: "DOWNLOAD_DSYMS_APP_IDENTIFIER",
                                       description: "The bundle identifier of your app",
                                       optional: false,
                                       code_gen_sensitive: true,
                                       default_value: CredentialsManager::AppfileConfig.try_fetch_value(:app_identifier),
                                       default_value_dynamic: true),
          FastlaneCore::ConfigItem.new(key: :team_id,
                                       short_option: "-k",
                                       env_name: "DOWNLOAD_DSYMS_TEAM_ID",
                                       description: "The ID of your App Store Connect team if you're in multiple teams",
                                       optional: true,
                                       is_string: false, # as we also allow integers, which we convert to strings anyway
                                       code_gen_sensitive: true,
                                       default_value: CredentialsManager::AppfileConfig.try_fetch_value(:itc_team_id),
                                       default_value_dynamic: true,
                                       verify_block: proc do |value|
                                         ENV["FASTLANE_ITC_TEAM_ID"] = value.to_s
                                       end),
          FastlaneCore::ConfigItem.new(key: :team_name,
                                       short_option: "-e",
                                       env_name: "DOWNLOAD_DSYMS_TEAM_NAME",
                                       description: "The name of your App Store Connect team if you're in multiple teams",
                                       optional: true,
                                       code_gen_sensitive: true,
                                       default_value: CredentialsManager::AppfileConfig.try_fetch_value(:itc_team_name),
                                       default_value_dynamic: true,
                                       verify_block: proc do |value|
                                         ENV["FASTLANE_ITC_TEAM_NAME"] = value.to_s
                                       end),
          FastlaneCore::ConfigItem.new(key: :platform,
                                       short_option: "-p",
                                       env_name: "DOWNLOAD_DSYMS_PLATFORM",
                                       description: "The app platform for dSYMs you wish to download (ios, appletvos)",
                                       optional: true,
                                       default_value: :ios),
          FastlaneCore::ConfigItem.new(key: :version,
                                       short_option: "-v",
                                       env_name: "DOWNLOAD_DSYMS_VERSION",
                                       description: "The app version for dSYMs you wish to download, pass in 'latest' to download only the latest build's dSYMs or 'live' to download only the live version dSYMs",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :build_number,
                                       short_option: "-b",
                                       env_name: "DOWNLOAD_DSYMS_BUILD_NUMBER",
                                       description: "The app build_number for dSYMs you wish to download",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :min_version,
                                       short_option: "-m",
                                       env_name: "DOWNLOAD_DSYMS_MIN_VERSION",
                                       description: "The minimum app version for dSYMs you wish to download",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :output_directory,
                                       short_option: "-s",
                                       env_name: "DOWNLOAD_DSYMS_OUTPUT_DIRECTORY",
                                       description: "Where to save the download dSYMs, defaults to the current path",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :wait_for_dsym_processing,
                                       short_option: "-w",
                                       env_name: "DOWNLOAD_DSYMS_WAIT_FOR_DSYM_PROCESSING",
                                       description: "Wait for dSYMs to process",
                                       optional: true,
                                       default_value: false,
                                       type: Boolean),
          FastlaneCore::ConfigItem.new(key: :wait_timeout,
                                       short_option: "-t",
                                       env_name: "DOWNLOAD_DSYMS_WAIT_TIMEOUT",
                                       description: "Number of seconds to wait for dSYMs to process",
                                       optional: true,
                                       default_value: 300,
                                       type: Integer)
        ]
      end

      def self.output
        [
          ['DSYM_PATHS', 'An array to all the zipped dSYM files']
        ]
      end

      def self.return_value
        nil
      end

      def self.authors
        ["KrauseFx"]
      end

      def self.is_supported?(platform)
        [:ios, :appletvos].include?(platform)
      end

      def self.example_code
        [
          'download_dsyms',
          'download_dsyms(version: "1.0.0", build_number: "345")',
          'download_dsyms(version: "live")',
          'download_dsyms(min_version: "1.2.3")'
        ]
      end

      def self.category
        :app_store_connect
      end
    end
  end
end
