#
# Cookbook:: tfc_agent
# Recipe:: default
#
# Copyright:: 2020, Michael Tharpe
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

remote_file "/tmp/tfc-agent-#{node['tfc_agent']['tfc_agent_version']}_linux_amd64.zip" do
  source "https://releases.hashicorp.com/tfc-agent/0.1.4/tfc-agent_#{node['tfc_agent']['tfc_agent_version']}_linux_amd64.zip"
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  not_if { ::File.exist?('/usr/bin/tfc_agent/tfc_agent') }
  notifies :extract, 'archive_file[tfc_agent_zip]', :immediately
end

archive_file 'tfc_agent_zip' do
  owner 'root'
  group 'root'
  mode '700'
  path "/tmp/tfc-agent-#{node['tfc_agent']['tfc_agent_version']}_linux_amd64.zip"
  destination "/usr/bin/tfc-agent-#{node['tfc_agent']['tfc_agent_version']}"
  action :nothing
  only_if { ::File.exist?("/tmp/tfc-agent-#{node['tfc_agent']['tfc_agent_version']}_linux_amd64.zip") }
end

link '/usr/bin/tfc-agent' do
  to "/usr/bin/tfc-agent-#{node['tfc_agent']['tfc_agent_version']}/tfc-agent"
end

template '/etc/systemd/system/tfc-agent.service' do
  source 'tfc-agent.service.erb'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  sensitive true
  notifies :restart, 'service[tfc-agent]', :immediately
end

service 'tfc-agent' do
  action [:enable, :start]
  supports status: true
end
