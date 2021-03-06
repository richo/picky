# encoding: utf-8
#
require 'spec_helper'

require 'ostruct'

describe 'GC stats: searching' do

  PoolSpecThing = Struct.new :id, :first, :last, :other
  
  before(:each) do
    Picky::Indexes.clear_indexes
  end
  
  let(:amount) { 5_000 }
  let(:data) do
    index = Picky::Index.new :sorted do
      category :first
      category :last
      category :other
    end
    3.times do |i|
      index.add PoolSpecThing.new(i+1, 'Abracadabra', 'Mirgel',  'whatever it')
      index.add PoolSpecThing.new(i+2, 'Abraham',     'Minder',  'is not too')
      index.add PoolSpecThing.new(i+3, 'Azzie',       'Mueller', 'unimportant')
    end
    index
  end
  let(:search) { Picky::Search.new data }

  # TODO Study what the problem is.
  #
  context 'without pool' do
    it 'runs the GC more' do
      # Quickly check if the pool is removed.
      #
      fail 'object pool still installed' if Picky::Query::Token.respond_to? :release_all
      
      try = search
      query = 'abracadabra mirgel'
      gc_runs_of do
        amount.times { try.search query }
      end.should <= 13
    end
    it 'is less (?) performant' do
      try = search
      query = 'abracadabra mirgel'
      performance_of do
        amount.times { try.search query }
      end.should <= 0.42
    end
  end
  context 'with pool' do
    before(:each) do
      Picky::Pool.install
    end
    after(:each) do
      # Reload since installing the Pool taints the classes.
      #
      Picky::Loader.load_framework
    end
    it 'runs the GC less' do
      # Quickly check that the pool is added.
      #
      fail 'object pool not installed' unless Picky::Query::Token.respond_to? :release_all
      
      try = search
      query = 'abracadabra mirgel'
      gc_runs_of do
        amount.times { try.search query; Picky::Pool.release_all }
      end.should <= 1 # Definitely less GC runs.
    end
    it 'is more (?) performant' do
      try = search
      query = 'abracadabra mirgel'
      performance_of do
        amount.times { try.search query }
      end.should <= 0.42
    end
  end
  
end