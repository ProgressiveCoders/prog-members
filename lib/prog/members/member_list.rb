class Prog::Members::MemberList < Airrecord::Table
  self.base_key   = ENV['AIRTABLE_APP']
  self.table_name = ENV['AIRTABLE_BASE']
end
