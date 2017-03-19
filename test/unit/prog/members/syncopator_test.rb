require 'test_helper'

describe Prog::Members::Syncopator do
  before do
    @subject = Prog::Members::Syncopator
    @params = {
      table:        MiniTest::Mock.new,
      slack_client: MiniTest::Mock.new,
    }

    # Airtable expectations
    @params[:table].expect(:ancestors, [Airrecord::Table], [])

    # Slack client expectations
    @params[:slack_client].expect(:is_a?, true, [Slack::Web::Client])
    @params[:slack_client].expect(:auth_test, @auth_test = MiniTest::Mock.new, [])
    @auth_test.expect(:ok, true, [])

    @params[:slack_client].expect(:users_list, @slack_users_list = MiniTest::Mock.new, [])
    @slack_users_list.expect(:members, [@slack_users_list_item = MiniTest::Mock.new], [])
    @slack_users_list_item.expect(:id, "abc123")
  end

  describe "as a class" do
    it "initializes properly" do
      @subject.new(@params).must_respond_to :call
    end

    it "errors when initialized without required dependencies" do
      -> { @subject.new(@params.reject { |k| k.to_s == 'table' }) }.must_raise RuntimeError
      -> { @subject.new(@params.reject { |k| k.to_s == 'slack_client' }) }.must_raise RuntimeError
    end
  end

  describe "when updating" do
    it "executes successfully when updating" do
      @params[:table].expect(:all, [@airtable_match = MiniTest::Mock.new], [{filter: '{slack_id} = "abc123"'}])

      @airtable_match.expect(:id, "rec123")
      @params[:table].expect(:find, @existing_record = MiniTest::Mock.new, ["rec123"])

      @slack_users_list_item.expect(:name, "ProgressiveCoder")
      @existing_record.expect(:[]=, "ProgressiveCoder", ["Member Handle", "ProgressiveCoder"])

      @slack_users_list_item.expect(:real_name, "Progressive Coder")
      @existing_record.expect(:[]=, "Progressive Coder", ["Member Name", "Progressive Coder"])

      @slack_users_list_item.expect(:tz, "America/Chicago")
      @existing_record.expect(:[]=, "America/Chicago", ["TZ", "America/Chicago"])

      @slack_users_list_item.expect(:tz_label, "Central Daylight Time")
      @existing_record.expect(:[]=, "Central Daylight Time", ["TZ Label", "Central Daylight Time"])

      @slack_users_list_item.expect(:profile, @profile = MiniTest::Mock.new)
      @profile.expect(:title, "I do things")
      @existing_record.expect(:[]=, "I do things", ["What I Do", "I do things"])

      @slack_users_list_item.expect(:deleted, false)
      @existing_record.expect(:[]=, false, ["Deleted?", false])

      @existing_record.expect(:save, true)

      result = @subject.new(@params).call
      result.successful?.must_equal true
      result.must_be_kind_of PayDirt::Result
    end
  end

  describe "when creating" do
    it "executes successfully when creating" do
      @params[:table].expect(:all, [], [{filter: '{slack_id} = "abc123"'}])

      @slack_users_list_item.expect(:name, "ProgressiveCoder")
      @slack_users_list_item.expect(:real_name, "Progressive Coder")
      @slack_users_list_item.expect(:tz, "America/Chicago")
      @slack_users_list_item.expect(:tz_label, "Central Daylight Time")
      @slack_users_list_item.expect(:profile, @profile = MiniTest::Mock.new)
      @profile.expect(:title, "I do things")
      @slack_users_list_item.expect(:deleted, false)
      @slack_users_list_item.expect(:id, "abc123")

      @params[:table].expect(:new, @new_record = MiniTest::Mock.new, [{
        "Member Handle"  => "ProgressiveCoder",
        "Member Name"    => "Progressive Coder",
        "TZ"             => "America/Chicago",
        "TZ Label"       => "Central Daylight Time",
        "What I Do"      => "I do things",
        "Deleted?"       => false,
        "slack_id"       => "abc123"
      }])
      @new_record.expect(:create, true)

      result = @subject.new(@params).call
      result.successful?.must_equal true
      result.must_be_kind_of PayDirt::Result
    end
  end

  describe "when freaking out" do
    it "executes successfully when freaking out" do
      @params[:table].expect(:all, [0, 1], [{filter: '{slack_id} = "abc123"'}])

      result = @subject.new(@params).call
      result.successful?.must_equal true
      result.must_be_kind_of PayDirt::Result
    end
  end
end
