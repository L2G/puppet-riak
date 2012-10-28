# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'spec_helper'

describe 'write_erl_config', :type => :puppet_function do
  def strip str
    str.gsub("\t", "").gsub("\n", "")
  end
  it { strip(subject.call([{ :a => 4 }])).should eq('[{a, 4}].') }
  it 'should gen correct erlang' do
    output = subject.call([{
      :lager => {
        :handlers => {
          :lager_file_backend   => [
            ['__tuple', '/var/log/riak/error.log', '__atom_error', 10485760, '$D0', 5],
          ],
          :error_logger_redirect => true
        }
      }
    }])
    strip(output).should eq('[{lager, [{handlers, [{error_logger_redirect, true},{lager_file_backend, [{"/var/log/riak/error.log", error, 10485760, "$D0", 5}]}]}]}].')
  end
  it 'should output numbers as numbers' do
    strip(subject.call([{ :a => [['__tuple', '__atom_mykey', 5 ]]}])).
      should eq('[{a, [{mykey, 5}]}].')
  end
end
