require_relative "../lib/prog/members"

@slack_client     = Slack::Web::Client.new(token: ENV['SLACK_API_TOKEN'])
Airrecord.api_key = ENV['AIRTABLE_KEY']

Prog::Members::Syncopator.new(slack_client: @slack_client, table: Prog::Members::MemberList).call
