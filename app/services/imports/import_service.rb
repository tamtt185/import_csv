class Imports::ImportService < BaseService
  attr_reader :log_file, :file_name, :file_path
  HEADER_HASH = {
    "Name" => "name",
    "Gender" => "gender"
  }

  GENDER_HASH = {
    "Nam" => "male",
    "Nu" => "female"
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

    columns = @header.map{|col| HEADER_HASH[col]}
    CSV.foreach(file_path, headers: false).drop(1).each.with_index(1) do |row, index|
      row = row.map{|value| value.squish}
      binding.pry
      row = [columns, row.map{|value| value.squish}].transpose.to_h
      row["gender"] = convert_gender row["gender"]
      binding.pry
      User.new row
    end
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

  def convert_gender gender
     GENDER_HASH[gender]
  end
end
