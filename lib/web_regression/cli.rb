require 'optparse'
require 'ostruct'

module WebRegression
  class Cli
    def self.parse_options(program,args)
      options = OpenStruct.new
      options.fastfail = false
      options.nodiff   = false
      options.opendiff = false
      options.reference_file = "/tmp/reference.png"
      
      opts = OptionParser.new do |opts|
        executable = File.basename(program)
        opts.banner = "Usage: #{executable} [options] URL"
        opts.separator ""
        
        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end
        
        opts.on("-r","--reference_png PNG_FILE","Png file to compare against") do |f|
          options.reference_file = f
        end
        
        opts.on("-f", "--fastfail","Fail as soon as a difference detected. Implies -n") do 
          options.fastfail = true
          options.nodiff = true
        end
        
        opts.on("-n", "--nodiff","Don't create a diff png") do 
          options.nodiff = true
        end
        
        opts.on("-o", "--opendiff","Open a png showing diffs highlighted with red border") do 
          options.opendiff = true
        end
        
        opts.on_tail("--version", "Show version") do
           puts WebRegression::VERSION
           exit
        end
      end
      opts.parse!(args)
      if ARGV.length != 1
        puts opts
        exit
      end
      options.url = ARGV[0]
      options
    end

    def self.execute(program,args)
      options = parse_options(program,args)
      app = WebRegression::Application.new(options)
      exit app.start
    end
  end
end
