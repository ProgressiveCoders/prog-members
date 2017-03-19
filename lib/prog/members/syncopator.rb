require 'pay_dirt'

module Prog
  module Members
    class Syncopator < PayDirt::Base
      def initialize(options = {})
        load_options(:table, :slack_client, options) do # after loading options
          # Validate Airtable / Airrecord
          raise unless @table.ancestors.include?(Airrecord::Table)

          # Validate Slack Client
          raise unless @slack_client.is_a?(Slack::Web::Client)
          raise unless @slack_client.auth_test.ok
        end
      end

      def call
        syncopate

        return result(true, nil)
      end

      private

        def syncopate
          @slack_client.users_list.members.each do |member|
            matches = @table.all({filter: "{slack_id} = \"#{member.id}\""})

            case matches.length
            when 0
              # create new record
              new_member = @table.new({
                "Member Handle"  => member.name,
                "Member Name"    => member.real_name,
                "TZ"             => member.tz,
                "TZ Label"       => member.tz_label,
                "What I Do"      => member.profile.title,
                "Deleted?"       => member.deleted,
                "slack_id"       => member.id,
              })

              new_member.create
            when 1
              # update existing record

              existing_member = @table.find(matches[0].id)
              existing_member["Member Handle"] = member.name
              existing_member["Member Name"]   = member.real_name
              existing_member["TZ"]            = member.tz
              existing_member["TZ Label"]      = member.tz_label
              existing_member["What I Do"]     = member.profile.title
              existing_member["Deleted?"]      = member.deleted

              existing_member.save
            else
              # just warn?
            end
          end
        end
    end
  end
end
