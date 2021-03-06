require 'spec_helper'

describe 'Test base configuration' do
    # Test if Docker is installed, enabled and running as a system service
    describe service('docker') do
        it { should be_enabled }
        it { should be_running }
    end

    # Test that Docker Compose tool is installed and available as CLI tool
    describe command('which docker-compose') do
        its(:exit_status) { should eq 0 }
    end

    # Test that AWS CLI is installed and available as CLI tool
    describe command('which aws') do
        its(:exit_status) { should eq 0 }
    end

    # Test that s3cmd is installed and available as CLI tool
    describe command('which s3cmd') do
        its(:exit_status) { should eq 0 }
    end

    # Test that custom script to start application is installed and available as CLI tool
    describe command('which start-application') do
        its(:exit_status) { should eq 0 }
    end

    # Test if directory where application should be located is created
    describe file('/usr/local/app') do
        it { should be_directory }
    end
end
