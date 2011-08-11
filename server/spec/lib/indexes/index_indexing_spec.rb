require 'spec_helper'

describe Picky::Indexes::Index do
  
  describe 'tokenizer' do
    context 'with tokenizer' do
      let(:tokenizer) { stub :tokenizer, :tokenize => '' }
      let(:index) do
        the_tokenizer = tokenizer
        described_class.new :some_name do
          source []
          indexing the_tokenizer
        end
      end

      it 'does things in order' do
        index.tokenizer.should == tokenizer
      end
    end
    context 'without tokenizer' do
      let(:index) do
        described_class.new :some_name do
          source []
        end
      end

      it 'does things in order' do
        index.tokenizer.should == Picky::Indexes.tokenizer
      end
    end
  end
  
  context 'in general' do
    context 'with #each source' do
      let(:index) do
        described_class.new :some_name do
          source []
        end
      end

      it 'does things in order' do
        index.should_receive(:check_source_empty).once.with.ordered
        index.should_receive(:index_in_parallel).once.with.ordered

        index.index
      end
    end
    context 'with non#each source' do
      let(:source) { stub :source, :harvest => nil }
      let(:index) do
        the_source = source
        described_class.new :some_name do
          source the_source
        end
      end

      it 'does things in order' do
        category = stub :category        
        index.stub! :categories => [
          category,
          category,
          category
        ]

        category.should_receive(:index).exactly(3).times

        index.index
      end
    end
  end
  
  context "with categories" do
    before(:each) do
      the_source = []
      
      @index = described_class.new :some_name do
        source the_source
      end
      @index.define_category :some_category_name1
      @index.define_category :some_category_name2
    end
    describe "raise_no_source" do
      it "should raise" do
        lambda { @index.raise_no_source }.should raise_error(Picky::NoSourceSpecifiedException)
      end
    end
    describe 'define_source' do
      it 'can be set with this method' do
        source = stub :source, :each => [].each
        
        @index.define_source source

        @index.source.should == source
      end
    end
    describe 'find' do
      context 'no categories' do
        it 'raises on none existent category' do
          expect do
            @index[:some_non_existent_name]
          end.to raise_error(%Q{Index category "some_non_existent_name" not found. Possible categories: "some_category_name1", "some_category_name2".})
        end
      end
      context 'with categories' do
        before(:each) do
          @index.define_category :some_name, :source => stub(:source)
        end
        it 'returns it if found' do
          @index[:some_name].should_not == nil
        end
        it 'raises on none existent category' do
          expect do
            @index[:some_non_existent_name]
          end.to raise_error(%Q{Index category "some_non_existent_name" not found. Possible categories: "some_category_name1", "some_category_name2", "some_name".})
        end
      end
    end
  end
  
  context "no categories" do
    it "works" do
      described_class.new :some_name do
        source []
      end
    end
  end
  
end