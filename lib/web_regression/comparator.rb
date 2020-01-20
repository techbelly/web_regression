require 'chunky_png'
require 'grover'
require 'tempfile'

class WebRegression::Comparator < Struct.new(:reference_file,:host,:path,:options)

  SUCCESS, FAILURE = 0,1

  def take_screenshot(file_name)
    grover = Grover.new(self.host+'/'+self.path)
    File.open(file_name, 'wb') do |file|
      file.write(grover.to_png)
    end
  end

  def ensure_reference_image
    unless File.exists?(self.reference_file)
      $stderr.puts "Creating a reference screenshot at #{self.reference_file}"
      take_screenshot(self.reference_file)
    end
  end

  def screenshot
    @screenshot ||= begin
      image_name = '/tmp/ss.png'
      take_screenshot(image_name)
      image_name
    end
  end

  def checksum_match?(file1, file2)
    ref_md5 = `md5 #{file1}`
    new_md5 = `md5 #{file2}`
    ref_md5 == new_md5
  end

  def reference_image
    @reference_image ||= ChunkyPNG::Image.from_file(self.reference_file)
  end

  def new_image
    @new_image ||= ChunkyPNG::Image.from_file(screenshot)
  end

  def highlight_diffs(new_image,diff)
     x, y = diff.map{ |xy| xy[0] }, diff.map{ |xy| xy[1] }

     new_image.rect(x.min, y.min, x.max, y.max, ChunkyPNG::Color.rgb(255,0,0))
     diff_path = '/tmp/diff.png'
     new_image.save(diff_path)

     if options.opendiff
       `open #{diff_path}`
     end
  end

  def compare
     ensure_reference_image

     $stdout.puts "Comparing page at #{self.host}/#{self.path} with #{self.reference_file}"

     if checksum_match?(self.reference_file,screenshot)
        $stdout.puts "No differences found."
        return SUCCESS
     end

     diff = []

     reference_image.height.times do |y|
       reference_image.row(y).each_with_index do |pixel, x|
         unless pixel == new_image[x,y]
          return FAILURE if options.fastfail
          diff << [x,y]
         end
       end
     end

     if diff.length == 0
        $stdout.puts "No differences found."
        return SUCCESS
     end

     unless options.nodiff
       highlight_diffs(new_image,diff)
     end
     $stderr.puts "#{diff.length} pixels of difference found"

     return FAILURE
  end

end
