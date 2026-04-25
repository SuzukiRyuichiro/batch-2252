require_relative '../lion'

describe Lion do
  describe "#talk" do
    it 'roars when it is asked to talk' do
      simba = Lion.new('Simba')

      expect(simba.talk).to eq('Simba roars')
    end
  end

  describe "#eat" do
    it 'returns a sentence with name and the food, and law of the jungle at the end' do
      simba = Lion.new('Simba')

      expect(simba.eat('gazelle')).to eq('Simba eats a gazelle. Law of the jungle!')
    end
  end
end
