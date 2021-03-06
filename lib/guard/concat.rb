require 'guard'
require 'guard/guard'
require 'guard/watcher'

module Guard
  class Concat < Guard

    VERSION = '0.0.3'

    def initialize(watchers=[], opts={})
      @output = "#{opts[:output]}.#{opts[:type]}"
      files = opts[:files].join("|")
      regex = %r{^#{opts[:input_dir]}/(#{files})\.#{opts[:type]}$}
      watcher = ::Guard::Watcher.new regex
      watchers << watcher
      @watchers, @opts = watchers, opts
      super watchers, opts
    end

    # # Calls #run_all if the :all_on_start option is present.
    # def start
    #   run_all if options[:all_on_start]
    # end

    # # Call #run_on_change for all files which match this guard.
    # def run_all
    #   run_on_changes(Watcher.match_files(self, Dir.glob('{,**/}*{,.*}').uniq))
    # end

    def run_on_changes(paths)
      concat
      UI.info "Concatenated #{@output}"
    end

    def concat
      content = ""
      files = []
      @opts[:files].each do |file|
        files << "#{@opts[:input_dir]}/#{file}.#{@opts[:type]}"
      end
      files.each do |file|
        content << File.read(file)
        content << "\n"
      end
      File.open(@output, "w"){ |f| f.write content.strip }
    end

  end
end
