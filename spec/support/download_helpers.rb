module DownloadHelpers
  TIMEOUT = 10

  def downloads_dir
    Capybara.save_path
  end

  def downloads
    Dir[downloads_dir.join("*")]
  end

  def download
    downloads.first
  end

  def download_content
    wait_for_download
    File.read(download)
  end

  def wait_for_download
    Timeout.timeout(TIMEOUT) do
      sleep 0.1 until downloaded?
    end
  end

  def downloaded?
    !downloading? && downloads.any?
  end

  def downloading?
    downloads.grep(/\.crdownload$/).any?
  end

  def clear_downloads
    FileUtils.rm_f(downloads)
  end
end

RSpec.configure do |config|
  config.include DownloadHelpers

  config.around(:each, type: :system) do |example|
    clear_downloads
    example.run
    clear_downloads
  end
end
