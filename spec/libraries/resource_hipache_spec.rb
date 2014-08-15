# Encoding: UTF-8
#
# Cookbook Name:: hipache
# Spec:: resource/hipache
#
# Copyright (C) 2014, Jonathan Hartman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require_relative '../spec_helper'
require_relative '../../libraries/resource_hipache'

describe Chef::Resource::Hipache do
  [:version, :config_path, :config].each { |i| let(i) { nil } }

  options =  [
    :access_log,
    :workers,
    :max_sockets,
    :dead_backend_ttl,
    :tcp_timeout,
    :retry_on_error,
    :dead_backend_on_500,
    :http_keep_alive,
    :https_port,
    :https_bind,
    :https_key,
    :https_cert,
    :http_port,
    :http_bind,
    :driver
  ]
  options.each { |o| let(o) { nil } }

  let(:resource) do
    r = described_class.new('my_hipache', nil)
    r.version(version)
    r.config_path(config_path)
    r.config(config)
    options.each { |o| r.send(o, send(o)) }
    r
  end

  describe '#initialize' do
    it 'defaults to the `install` action' do
      expect(resource.instance_variable_get(:@action)).to eq(:install)
      expect(resource.action).to eq(:install)
    end

    it 'defaults the state to uninstalled' do
      expect(resource.instance_variable_get(:@installed)).to eq(false)
      expect(resource.installed?).to eq(false)
    end
  end

  describe '#version' do
    context 'no override provided' do
      it 'defaults to the latest version' do
        expect(resource.version).to eq('latest')
      end
    end

    context 'a valid override provided' do
      let(:version) { '1.2.3' }

      it 'returns the overridden value' do
        expect(resource.version).to eq(version)
      end
    end

    context 'an invalid override provided' do
      let(:version) { '1.2.z' }

      it 'raises an exception' do
        expect { resource }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end

  describe '#config_path' do
    context 'no override provided' do
      it 'defaults to "/etc/hipache.json"' do
        expect(resource.config_path).to eq('/etc/hipache.json')
      end
    end

    context 'a valid override provided' do
      let(:config_path) { '/var/hip' }

      it 'returns the overridden value' do
        expect(resource.config_path).to eq(config_path)
      end
    end

    context 'an invalid override provided' do
      let(:config_path) { :test }

      it 'raises an exception' do
        expect { resource }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end

  options.each do |method|
    describe "##{method}" do
      context 'no override provided' do
        it 'returns the default' do
          expected = Chef::Resource::Hipache::VALID_OPTIONS[method][:default]
          expect(resource.send(method)).to eq(expected)
        end
      end

      context 'a valid override provided' do
        let(method) do
          kinds = Chef::Resource::Hipache::VALID_OPTIONS[method][:kind_of]
          cls = kinds.is_a?(Array) ? kinds[0] : kinds
          case cls.to_s
          when 'String'
            'so-crates'
          when 'Fixnum'
            98
          when 'TrueClass'
            false
          end
        end

        it 'returns the overridden value' do
          expect(resource.send(method)).to eq(send(method))
        end

        context 'an invalid option combo' do
          let(:config) { { access_log: '/tmp/log.log' } }

          it 'raises an exception' do
            expected = Chef::Exceptions::ValidationFailed
            expect { resource }.to raise_error(expected)
          end
        end
      end

      context 'an invalid override provided' do
        let(method) do
          kinds = Chef::Resource::Hipache::VALID_OPTIONS[method][:kind_of]
          cls = kinds.is_a?(Array) ? kinds[0] : kinds
          case cls.to_s
          when 'String'
            { twenty: 'one' }
          when 'Fixnum'
            :something
          when 'TrueClass'
            'nothing'
          end
        end

        it 'raises an exception' do
          expect { resource }.to raise_error(Chef::Exceptions::ValidationFailed)
        end
      end
    end
  end

  describe '#config' do
    context 'no override provided' do
      it 'returns the default' do
        expect(resource.config).to eq(nil)
      end
    end

    context 'a valid override provided' do
      let(:config) { { access_log: '/tmp/log.log' } }

      it 'returns the overridden value' do
        expect(resource.config).to eq(config)
      end

      options.each do |opt|
        it "sets #{opt} to nil" do
          expect(resource.send(opt)).to eq(nil)
        end
      end
    end

    context 'an invalid override provided' do
      let(:config) { :monkeys }

      it 'raises an exception' do
        expect { resource }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end
end