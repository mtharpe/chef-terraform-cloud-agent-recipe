# InSpec test for recipe tfc_agent::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

describe file('/etc/systemd/system/tfc-agent.service') do
  it { should exist }
end

describe service('tfc-agent') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
