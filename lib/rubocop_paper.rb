require "rubocop_paper/version"
require "thor"
require "json"
require "csv"

module RubocopPaper
  class CLI < Thor
    default_command :rubocop_csv

    # rubocop_csv
    # @param [String] json_file json形式のファイル。rubocopのアウトプット
    desc "convert input string to csv", "convert input string to csv"
    def rubocop_csv(json_file)
      # 変数の定義
      output_file="rubocop_file_stat.csv"
      res = nil
      offenses = {}

      # 出力されたjson形式のファイルをCSV形式にフォーマットし直す
      # @see http://rubocop.readthedocs.io/en/latest/formatters/#json-formatter
      File.open(json_file) do |f|
        json_str = f.read
        res = JSON.parse(json_str)
      end

      res["files"].each do |t_f|
        path = t_f["path"]
        t_f["offenses"].each do |o|
          # offensesの各配列要素o（ハッシュ）が持つキー
          # - severity
          # - message
          # - cop_name
          # - corrected
          # - location(line, column, length)
          cop_name = o["cop_name"]
          unless offenses[cop_name]
            # 初期化
            offenses[cop_name] = {
              count: 1,
              files: [Util.file_info(path, o)],
              metrics: [Util.get_metrics(o)],
              severity: o["severity"],
              message: o["message"],
            }
          else
            offenses[cop_name][:count] += 1
            offenses[cop_name][:files] << Util.file_info(path, o)
            offenses[cop_name][:metrics] << Util.get_metrics(o)
          end
        end
      end

      rows = [["Cop Name", "Severity", "Message", "Count"]]
      offenses.each do |cop_name, h|
        rows << [cop_name, h[:severity].upcase, h[:message], h[:count]]
      end
      cols1 = Util.transpose_f(rows)

      rows = [["Path & Location"]]
      offenses.each do |_, h|
        rows << h[:files]
      end
      cols2 = Util.transpose_f(rows)

      rows = [["Metrics"]]
      offenses.each do |_, h|
        rows << h[:metrics]
      end
      cols3 = Util.transpose_f(rows)

      CSV.open(output_file, "wb") do |csv|
        cols1.each { |row| csv << row }
        cols2.each { |row| csv << row }
        cols3.each { |row| csv << row }
      end

    end
  end

  class Util
    # 2次元配列を転置する
    # Array#transposeだと配列サイズの不一致によるエラーが発生するので自前で実装
    # @param [Array<Array>] array
    # @return 転置された配列
    def self.transpose_f(array)
      transposed_array = []
      array.each.with_index do |row, row_no|
        row.each.with_index do |_, col_no|
          transposed_array[col_no] ||= []
          transposed_array[col_no][row_no] = array[row_no][col_no]
        end
      end
      transposed_array
    end

    # 違反箇所情報を文字列で返す
    # @param [String] path ファイルパス
    # @param [Hash] h 配列offensesの各ハッシュ要素
    # @return [String] 発生位置情報
    def self.file_info(path, h)
      info = "#{h["severity"][0,1].upcase}: " +
             "#{path}(#{h["location"]["line"]},#{h["location"]["column"]}) "
      m = h["message"].match(/\[[0-9]+(\.[0-9]+)?\/[0-9]+\]/)
      info += m[0] if m
      info
    end

    # 数値的なメトリクス情報のみ取得
    def self.get_metrics(h)
      m = h["message"].match(/\[([0-9]+(\.[0-9]+)?)\/[0-9]+\]/)
      m ? m[1] : nil
    end
  end
end
