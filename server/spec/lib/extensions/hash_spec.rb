require 'spec_helper'

describe Hash do

  describe "to_json" do
    let(:obj) do
      # A very realistic example.
      #
      { :allocations => [
          ['c', 17.53, 275179, [["name","s*","s"]],[]],
          ['c', 15.01, 164576, [["category","s*","s"]],[]],
          ['p', 12.94, 415634, [["street","s*","s"]],[]],
          ['p', 12.89, 398247, [["name","s*","s"]],[]],
          ['p', 12.67, 318912, [["city","s*","s"]],[]],
          ['p', 12.37, 235933, [["first_name","s*","s"]],[]],
          ["p", 11.76, 128259, [["maiden_name","s*","s"]],[]],
          ['p', 11.73, 124479, [["occupation","s*","s"]],[]],
          ['c', 11.35,  84807, [["street","s*","s"]],[]],
          ['c', 11.15,  69301, [["city","s*","s"]],[]],
          ['p', 4.34,      77, [["street_number","s*","s"]],[]],
          ['c', 2.08,       8, [["street_number","s*","s"]],[]],
          ['c', 1.61,       5, [["adword","s*","s"]],[]]
        ],
        :offset   => 0,
        :duration => 0.04,
        :total    => 2215417
      }
    end
    it "should be correct" do
      obj.to_json.should == '{"allocations":[["c",17.53,275179,[["name","s*","s"]],[]],["c",15.01,164576,[["category","s*","s"]],[]],["p",12.94,415634,[["street","s*","s"]],[]],["p",12.89,398247,[["name","s*","s"]],[]],["p",12.67,318912,[["city","s*","s"]],[]],["p",12.37,235933,[["first_name","s*","s"]],[]],["p",11.76,128259,[["maiden_name","s*","s"]],[]],["p",11.73,124479,[["occupation","s*","s"]],[]],["c",11.35,84807,[["street","s*","s"]],[]],["c",11.15,69301,[["city","s*","s"]],[]],["p",4.34,77,[["street_number","s*","s"]],[]],["c",2.08,8,[["street_number","s*","s"]],[]],["c",1.61,5,[["adword","s*","s"]],[]]],"offset":0,"duration":0.04,"total":2215417}'
    end
    it "should take options" do
      lambda { obj.to_json(:some => :option) }.should_not raise_error
    end
    it "should be fast" do
      obj.to_json # Prerun
      performance_of { obj.to_json }.should < 0.000065
    end
  end

end