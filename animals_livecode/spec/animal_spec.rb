require_relative '../animal'

describe Animal do
  describe "#initialize" do
    it 'make an instance with a name' do
      antonio = Animal.new('Antonio')

      expect(antonio).to be_an(Animal)
    end

    it 'returns the name when it is asked' do
      antonio = Animal.new('Antonio')

      expect(antonio.name).to eq('Antonio')
    end
  end

  describe "::habitats" do
    it 'returns an array of animal habitats' do
      habitats = [ "Jungle", "Desert", "Grassland", "Forest", "Ocean", "Mountain"]

      expect(Animal.habitats).to eq(habitats)
    end
  end


  describe "#eat" do
    it 'returns a sentence with name and the food' do
      antonio = Animal.new('Antonio')

      expect(antonio.eat('pizza')).to eq('Antonio eats a pizza.')
    end
  end
end
