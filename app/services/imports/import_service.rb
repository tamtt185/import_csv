class Imports::ImportService < BaseService
  attr_reader :log_file, :file_name, :file_path
  HEADER_HASH = {
    "Name" => "name",
    "Gender" => "gender"
  }

  def initialize **args
    # @log_file = args[:log_file]
    @file_name = args[:file_name]
    @file_path = args[:file_path]
    @errors_count = 0
  end

  def call
    return unless file_existed?

    @header = get_header
    return unless check_header_file?
  end

  private

  def get_header
    CSV.foreach(file_path).first.map{|col| col.squish}
  end

  def file_existed?
    return true if File.exist? file_path

    @errors_count += 1
    @log_file.error "The #{file_path} is not existed in the system."
    false
  end

  def check_header_file?
    return true if (HEADER_HASH.keys - @header).blank?

    @errors_count += 1
    @log_file.error "Import fail, Headers of file invalid"
    false
  end
end
