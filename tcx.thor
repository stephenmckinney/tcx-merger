require 'nokogiri'

class Tcx < Thor
  desc "merge FILE1 FILE2", "merge two .tcx files"
  def merge(one_file_name, two_file_name)
    one = File.open(one_file_name)
    two = File.open(two_file_name)
    merged = File.open("merged.tcx", "w")

    one_doc = Nokogiri::XML(one)
    two_doc = Nokogiri::XML(two).remove_namespaces!

    search = "Activities Activity Lap"
    laps = two_doc.css(search)
    laps.each do |lap|
      append_to = one_doc.css(search).last
      append_to.add_next_sibling(lap)
    end

    merged.write(one_doc)

    one.close
    two.close
    merged.close
    say "#{one_file_name} and #{two_file_name} have been merged into merged.tcx"
  end
end

