require 'helper'
require 'test/unit/assertions'

require 'conversions'

#Conversationalist.debug = true

describe Conversationalist do
  include Test::Unit::Assertions

  describe '.parse' do
    it 'should not convert already-base numbers' do
      assert_equal 1.0, Conversationalist.parse('1 metre').to_f
    end

    it "should parse number of kilometres into metres" do
      assert_equal 1_000.0, Conversationalist.parse('1 kilometre').to_f
    end
    
    it "should parse mixed case units" do
      assert_equal 2_000.0, Conversationalist.parse('2 KiloMetres').to_f
      assert_equal 4023.36, Conversationalist.parse('2.5 Miles')
    end
    
    it "should parse units from within a string of other text" do
      assert_equal 1.25, Conversationalist.parse("1 Package (1.25 grams) taco seasoning mix")
      assert_equal 16, Conversationalist.parse("1 Can (16 grams) tomatoes, undrained")
      
      assert_equal 15, Conversationalist.parse("John ran 15 metres")
    end
    
    it "should ignore units of measure that Conversions does not understand" do
      assert_equal nil, Conversationalist.parse('2 awesomes')
    end
    
    # add tests for all units Conversions can handle
    Conversions.conversions.keys.each do |unit|
      it "should parse #{unit}" do
        assert_equal 1.send(unit).to(Conversationalist.base(unit)),
          Conversationalist.parse("1 #{unit}")
        assert_equal 2.5.send(unit).to(Conversationalist.base(unit)),
          Conversationalist.parse("2.5 #{unit}")
      end
      
      # tests for all multi word units
      if (words = unit.to_s.split('_')).length > 1
        it "should parse multiword unit '#{words.join(' ')}'" do
          assert_equal 1.send(unit), Conversationalist.parse("1 #{words.join(' ')}")
          assert_equal 2.5.send(unit), Conversationalist.parse("2.5 #{words.join(' ')}")
        end
      end
    end
  end

  describe '.base' do
    it 'returns the same unit for a given base' do
      Conversationalist.base('meter').should == :meter
    end
    it 'returns a base length unit' do
      Conversationalist.base('kilometer').should == :meter
      Conversationalist.base('mile').should == :meter
      Conversationalist.base('foot').should == :meter
    end
  end
end
