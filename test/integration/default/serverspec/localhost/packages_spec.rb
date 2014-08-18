# Encoding: UTF-8
#
# Cookbook Name:: hipache
# Spec:: serverspec/localhost/packages
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

require 'spec_helper'

describe 'packages' do
  describe package('nodejs') do
    it 'is installed' do
      expect(described_class).to be_installed
    end
  end

  describe package('npm::hipache') do
    it 'is installed' do
      expect(command('npm info hipache')).to return_exit_status(0)
    end
  end
end
