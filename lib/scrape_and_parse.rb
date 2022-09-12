require 'csv'
require 'fileutils'
require 'capybara/poltergeist'

class ScrapeAndParse
  URL = "https://www.saucedemo.com/"
  USER_LOGIN = 'standard_user'
  USER_PSWD = 'secret_sauce'
  version = Time.now.to_i
  PATH = "./result/#{version}"

  def scrape
    puts '------start scrape'
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, {
        js_errors: false,
        timeout: 600,
        phantomjs_options: %w[--load-images=no --ignore-ssl-errors=yes --ssl-protocol=any] })
    end

    # Configure Capybara to use Poltergeist as the driver
    Capybara.default_driver = :poltergeist

    browser = Capybara.current_session
    browser.visit URL

    if browser
      # browser.fill_in 'user-name', with: 'standard_user'
      login = browser.find("#user-name").click
      login.send_keys USER_LOGIN

      # browser.fill_in 'password', with: 'secret_sauce'
      pswd = browser.find("#password").click
      pswd.send_keys USER_PSWD

      browser.click_on 'login-button'

      puts '------end scrape'
      browser.all('.inventory_item')
    end
  rescue StandardError => e
    puts "e.message: #{e.message}"
    puts e
    puts e.backtrace.join("\n")
  end

  def create_csv(data)
    puts '------start csv'
    csv_rows = []

    dirname = create_dir(PATH)

    data.each do |el|
      title = el.find('.inventory_item_name').text
      desc = el.find('.inventory_item_desc').text
      price = el.find('.inventory_item_price').text
      csv_rows << [title, desc, price]
    end

    CSV.open("#{dirname}/result.csv", 'wb') do |csv|
      csv_rows.each do |csv_row|
        csv << csv_row
      end
    end
    puts "----------cols: #{csv_rows.size}"
    puts '------end csv'
  end

  def create_dir(dir)
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    "#{dir}/"
  end

end
