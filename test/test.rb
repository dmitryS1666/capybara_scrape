require_relative "../lib/scrape_and_parse"
require "test/unit"

class TestScrapeAndParse < Test::Unit::TestCase

  def test_scrape
    s_a_p = ScrapeAndParse.new
    data = s_a_p.scrape
    assert_operator(0, :<, data.size)
    # assert_equal(6, SimpleNumber.new(2).multiply(3) )
  end

  def test_csv
    s_a_p = ScrapeAndParse.new
    data = s_a_p.scrape
    csv = s_a_p.create_csv(data)

    assert_operator(0, :<, csv.size)
  end

end
