require 'rugzip/decompressor'
require 'spec_helper'

describe Rugzip::Decompressor do
  let(:decompressed) { 'foobar' }

  let(:compressed) do
    "\x1f\x8b\x08\x00\xdf\x95\x6c\x52\x00\x03\x4b\xcb\xcf\x4f\x4a\x2c\x02" \
    "\x00\x95\x1f\xf6\x9e\x06\x00\x00\x00"
  end
  
  let(:input)  { StringIO.new(compressed) }
  let(:output) { StringIO.new }
  
  subject { Rugzip::Decompressor.new(input, output) }
  
  describe '#decompress' do
    it 'should decompress a simple string' do
      subject.decompress.string.must_equal(decompressed)
    end
    
    describe 'with no input' do
      let(:input) { StringIO.new }
      
      it 'should raise an error' do
        proc { subject.decompress }.must_raise(Rugzip::Decompressor::BadIO)
      end
    end
    
    describe 'with bad input' do
      let(:input) { StringIO.new('thereisnogzipheaderinthisfakestring') }
      
      it 'should raise an error' do
        proc { subject.decompress }.must_raise(Rugzip::Decompressor::BadIO)
      end
    end
    
    describe 'with a large input' do
      let(:input) do
        compressed = `cat /usr/share/dict/words | gzip -8 --stdout`
        StringIO.new(compressed)
      end
      
      it 'should decompress correctly' do
        skip unless File.exist?('/usr/share/dict/words') && !`which gzip`.empty?
        subject.decompress.string.must_equal(File.read('/usr/share/dict/words'))
      end
    end
  end
end
