module Validator
  module Api
    class FogOpenStack
      class << self
        def compute
          handle_socket_error do
            Fog::Compute::HuaweiCloud.new(convert_to_fog_params(openstack_params))
          end
        end

        def network
          handle_socket_error do
            Fog::Network::HuaweiCloud.new(convert_to_fog_params(openstack_params))
          end
        end

        def image
          handle_socket_error do
            begin
              Fog::Image::HuaweiCloud::V2.new(convert_to_fog_params(openstack_params))
            rescue Fog::HuaweiCloud::Errors::ServiceUnavailable
              Fog::Image::HuaweiCloud::V1.new(convert_to_fog_params(openstack_params))
            end
          end
        end

        def volume
          handle_socket_error do
            begin
              Fog::Volume::HuaweiCloud::V2.new(convert_to_fog_params(openstack_params))
            rescue Fog::HuaweiCloud::Errors::ServiceUnavailable, Fog::Errors::NotFound
              Fog::Volume::HuaweiCloud::V1.new(convert_to_fog_params(openstack_params))
            end
          end
        end

        def storage(storage_params = {})
          fog_params = convert_to_fog_params(openstack_params)
          fog_params.merge!(storage_params)

          handle_socket_error do
            Fog::Storage::HuaweiCloud.new(fog_params)
          end
        end

        def with_openstack(error_message)
          yield if block_given?
        rescue => e
          log_path = RSpec.configuration.options.log_path
          logger = Logger.new(File.join(log_path, 'testsuite.log'))
          logger.error(e.message)
          message = "More details can be found in '#{log_path}'"
          if e.class == Excon::Errors::Forbidden
            message = "The user '#{Validator::Api.configuration.openstack['username']}' does not have required permissions."
          end
          fail("#{error_message}: #{message}")
        end

        private

        def handle_socket_error(&block)
          yield
        rescue Excon::Errors::SocketError => e
          raise ValidatorError, "Could not connect to '#{openstack_params['auth_url']}'", e.backtrace
        end

        def openstack_params
          Api.configuration.openstack
        end

        def convert_to_fog_params(options)
          add_exconn_instrumentor(options)
          {
              :huaweicloud_auth_url => options['auth_url'],
              :huaweicloud_username => options['username'],
              :huaweicloud_api_key => options['api_key'],
              :huaweicloud_tenant => options['tenant'],
              :huaweicloud_project_name => options['project'],
              :huaweicloud_domain_name => options['domain'],
              :huaweicloud_region => options['region'],
              :huaweicloud_endpoint_type => options['endpoint_type'],
              :connection_options => options['connection_options']
          }
        end

        def add_exconn_instrumentor(options)
          if options['connection_options']
            options['connection_options'].merge!({ 'instrumentor' => Validator::Instrumentor })
          end
        end
      end
    end
  end
end
