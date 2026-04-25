require_relative '../warthog'

describe Warthog do
  describe "#talk" do
    it 'grunts when it is asked to talk' do
      pumbaa = Warthog.new('Pumbaa')

      expect(pumbaa.talk).to eq('Pumbaa grunts')
    end
  end
end
