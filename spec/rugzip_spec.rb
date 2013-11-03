require 'rugzip'
require 'spec_helper'

describe Rugzip do
  subject { Rugzip }
  
  let(:decompressed) { 'foobar' }
  
  describe 'decompress/compress' do
    it 'should decompress data compressed with compress' do
      input  = StringIO.new(decompressed)
      output = StringIO.new
      subject.compress(input, output)
      
      input  = output
      output = StringIO.new
      subject.decompress(input, output)
      
      output.string.must_equal(decompressed)
    end
  end
end
