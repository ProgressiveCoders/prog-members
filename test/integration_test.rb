require "minitest/autorun"
require_relative "../lib/prog/members"

class CredentialsTest < Minitest::Test
  def setup
    @slack_client     = Slack::Web::Client.new(token: ENV['SLACK_API_TOKEN'])
    Airrecord.api_key = ENV['AIRTABLE_KEY']
  end

  def test_slack
    assert_equal true, @slack_client.auth_test.ok
  end

  def test_airtable
    assert Prog::Members::MemberList.records.count >= 1
  end
end
