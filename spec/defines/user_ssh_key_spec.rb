require 'spec_helper'

describe 'administrable_as_user::user_ssh_key' do
  let(:title) { 'ssh-ed25519 PUBLIC_KEY_HERE anyone@anyhost.example.com' }
  let(:params) do
    {
      'user' => 'dummy',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
