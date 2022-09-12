# frozen_string_literal: true

require_relative '../lib/scrape_and_parse'

def main
  s_a_p = ScrapeAndParse.new
  data = s_a_p.scrape
  s_a_p.create_csv(data) unless data.nil?
end
